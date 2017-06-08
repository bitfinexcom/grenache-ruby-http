'use strict'

const Grenache = require('./../../')
const Link = Grenache.Link
const Peer = Grenache.PeerRPCClient
const fs = require('fs')
const path = require('path')

const secure = {
  key: fs.readFileSync(path.join(__dirname, 'client1-key.pem')),
  cert: fs.readFileSync(path.join(__dirname, 'client1-crt.pem')),
  ca: fs.readFileSync(path.join(__dirname, 'ca-crt.pem')),
  rejectUnauthorized: false // take care, can be dangerous in production!
}

const link = new Link({
  grape: 'ws://127.0.0.1:30001'
})
link.start()

const peer = new Peer(link, {secure: secure})
peer.init()

const reqs = 1000
let reps = 0

setTimeout(() => {
  const d1 = new Date()
  for (let i = 0; i < reqs; i++) {
    peer.request('rpc_test', 'hello', { timeout: 100 }, (err, data) => {
      console.log(err, data)
      if (err) {
        console.error(err)
        process.exit(-1)
      }
      console.log(err, data)
      if (++reps === reqs) {
        const d2 = new Date()
        console.log(d2 - d1)
      }
    })
  }
}, 2000)
