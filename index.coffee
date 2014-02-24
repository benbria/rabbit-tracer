app = require('express')()
server = require('http').createServer(app)
io = require('socket.io').listen(server)
amqp = require('amqplib')

port = 8099

amqpServer = process.argv[2] ? 'amqp://localhost'
console.log "Connecting to server #{amqpServer}"

connection = null
derp = amqp.connect(amqpServer)
    .then (conn) ->
        console.log "Connected to RabbitMQ"
        return conn.createChannel().then (ch) ->
            return ch.assertQueue('', { exclusive: true, autoDelete: true }).then ({ queue }) ->
                return ch.bindQueue(queue, 'amq.rabbitmq.trace', 'publish.*').then ->
                    ch.consume queue, ({content, properties: { headers: { exchange_name, routing_keys } }}) ->
                        io.sockets.emit 'message', { content: content.toString(), exchange_name, routing_keys }
                    , { noAck: true }
   .otherwise (err) ->
       console.error "Error:", err.message
       process.exit -1

app.get '/', (req, res) -> res.sendfile "#{__dirname}/index.html"

io.set 'log level', 2
server.listen port, '::'

console.log "Listening on port #{port}"
