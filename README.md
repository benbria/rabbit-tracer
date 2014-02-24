rabbit-tracer
=============

A simple web application that connects to RabbitMQ, listens to the `amq.rabbitmq.trace` exchange, and displays all messages received.

Run with `npm start` and go to http://localhost:8099/. Make sure the firehose is turned on: `rabbitmqctl trace_on`.
