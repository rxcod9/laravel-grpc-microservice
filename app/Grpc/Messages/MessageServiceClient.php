<?php
// GENERATED CODE -- DO NOT EDIT!

namespace Messages;

/**
 */
class MessageServiceClient extends \Grpc\BaseStub {

    /**
     * @param string $hostname hostname
     * @param array $opts channel options
     * @param \Grpc\Channel $channel (optional) re-use channel object
     */
    public function __construct($hostname, $opts, $channel = null) {
        parent::__construct($hostname, $opts, $channel);
    }

    /**
     * @param \Messages\MessageRequest $argument input argument
     * @param array $metadata metadata
     * @param array $options call options
     * @return \Grpc\UnaryCall
     */
    public function SendMessage(\Messages\MessageRequest $argument,
      $metadata = [], $options = []) {
        return $this->_simpleRequest('/messages.MessageService/SendMessage',
        $argument,
        ['\Messages\MessageResponse', 'decode'],
        $metadata, $options);
    }

}
