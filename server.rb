require 'em-websocket'

EM.run {
  @channel = EM::Channel.new
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|

    ws.onopen {
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push "#{sid} connected!"

      ws.onmessage { |msg|
        @channel.push "<#{sid}>: #{msg}"
      }

      ws.onclose {
        @channel.unsubscribe(sid)
      }
    }

  end
}
