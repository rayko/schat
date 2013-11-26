require 'em-websocket'

EM.run {
  @channel = EM::Channel.new
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|

    ws.onopen { |handshake|
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push "Joined the room."
      puts "#{sid} connected."

      ws.onmessage { |msg|
        @channel.push "[#{msg.split(',').first}] #{msg.split(',').last}"
        puts "#{sid}: #{msg}"
      }

      ws.onclose {
        @channel.unsubscribe(sid)
        puts "#{sid} left."
      }
    }

  end
}
