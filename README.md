# grenache-ruby-http

# Configuration

```ruby
Grenache::Base.configure do |conf|
    conf.grape_address = "http://10.0.0.1:30002"
end
```

# Usage

## Announce a service

```ruby
c = Grenache::Base.new

c.listen("test",5001) do |env|
    req = Oj.load(env['rack.input'].read)
    [200,nil,"hello #{req}"]
end
```


## lookup for a service

```ruby
c.request('test', 'world')
```

