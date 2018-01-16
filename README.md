# grenache-ruby-http

<img src="logo.png" width="15%" />

Grenache is a micro-framework for connecting microservices. Its simple and optimized for performance.

Internally, Grenache uses Distributed Hash Tables (DHT, known from Bittorrent) for Peer to Peer connections. You can find more details how Grenche internally works at the [Main Project Homepage](https://github.com/bitfinexcom/grenache)

 - [Setup](#setup)
 - [Examples](#examples)
 - [API](#api)

## Setup

### Install
```
gem install grenache-ruby-http
```

### Other Requirements

Install `Grenache Grape`: https://github.com/bitfinexcom/grenache-grape:

```bash
npm i -g grenache-grape
```

```
// Start 2 Grapes
grape --dp 20001 --aph 30001 --bn '127.0.0.1:20002'
grape --dp 20002 --aph 40001 --bn '127.0.0.1:20001'
```

## Examples

#### RPC Server / Client

This RPC Server example announces a service called `rpc_test`
on the overlay network. When a request from a client is received,
it replies with `world`. It receives the payload `hello` from the
client.

The client sends `hello` and receives `world` from the server.

Internally the DHT is asked for the IP of the server and then the
request is done as Peer-to-Peer request via websockets.

**Grape:**

```bash
grape --dp 20001 --aph 30001 --bn '127.0.0.1:20002'
grape --dp 20002 --aph 40001 --bn '127.0.0.1:20001'
```

**Server:**

```rb
require "grenache-ruby-http"

EM.run do
  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Http.new(grape_address: "http://127.0.0.1:40001/")
  port = 5001

  c.listen("test_service", port) do |req|
      "hello #{req.payload}"
  end
end
```

**Client:**

```rb
require "grenache-ruby-http"

c = Grenache::Http.new(grape_address: "http://127.0.0.1:40001/")

resp, err = c.request("test_service", "world")

puts "response: #{resp}"

```

[Code Server](https://github.com/bitfinexcom/grenache-ruby-http/blob/master/examples/worker.rb)
[Code Client](https://github.com/bitfinexcom/grenache-ruby-http/blob/master/examples/client.rb)

## API

### Class: Grenache::Http

### Grenache::Http.new(options)
  - `options`
    - `:grape_address` &lt;String&gt;
    - `:timeout` &lt;Number&gt;

    - `:auto_announce_interval` &lt;Number&gt;
    - `:auto_announce` &lt;Boolean&gt;
    - `:service_timeout` &lt;Number&gt;
    - `:service_host` &lt;String&gt;

    - `:key` &lt;String&gt; SSL: Path to key file
    - `:cert_pem` &lt;String&gt; SSL: Path to chain file
    - `:ca` &lt;String&gt; SSL: Path to ca file
    - `:service_host` &lt;String&gt; SSL: host name, used for worker
    - `:reject_unauthorized` SSL: Reject unauthorized certs
    - `:verify_mode` SSL: Verification method, default `Grenache::SSL_VERIFY_PEER`


### client.request(name, payload, options)
  - `name` &lt;String&gt; Name of the service to address
  - `payload` Payload to send
  - `options`
    - `:timeout` Timeout for the request

Sends a single request to a RPC server/worker.
[Example](https://github.com/bitfinexcom/grenache-ruby-http/blob/master/examples/client.rb).


### client.put(data, options)

  - `data`
    - `:v`: &lt;String&gt; value to store
  - `options`
    - `:timeout` Timeout for the request

Puts a value into the DHT.

### client.get(hash)
  - `hash` &lt;String&gt; Hash of the data to receive

Retrieves a stored value from the DHT via a `hash` &lt;String&gt;.

### client.listen(key, port, options)
  - `name` &lt;String&gt; Name of the service to announce
  - `port` &lt;Number&gt; Port to listen
  - `options`

Sets up a worker which connects to the DHT.
Listens on the given `port`.

[Example](https://github.com/bitfinexcom/grenache-ruby-http/blob/master/examples/worker.rb).
