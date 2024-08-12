const express = require('express')
const app = express()
const port = 3000
const request = require('request');

app.get('/', (req, res) => {
  request('http://169.254.169.254/latest/dynamic/instance-identity/document', function (error, response, body) {
    res.send('Hello Instance:' + JSON.stringify(response));
  });
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})