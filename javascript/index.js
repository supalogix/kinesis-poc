const AWS = require('aws-sdk')
const firehoser = require("firehoser")

AWS.config.update({
    region: "us-east-1",
    // put your access key here
    accessKeyId: "", 
    // put your secret access key here
    secretAccessKey: "" 
})

const deliveryStreamName = "xxx-scaling-firehose-1"

const firehose = new firehoser.JSONDeliveryStream(deliveryStreamName)

firehose.putRecord({
    key: "value"
})

firehose.putRecords([
    {
        a: 1,
        b: 2,
        c: 3
    },
    {
        a: 2,
        b: 3,
        c: 4
    },
    {
        a: 3,
        b: 4,
        c: 5
    }
])