<?php

namespace App\Services;

use Spiral\RoadRunner\GRPC;
use Messages\MessageRequest;
use Messages\MessageResponse;

class MessageService implements MessageServiceInterface
{
    public const NAME = 'messages.MessageService';

    public function SendMessage(
        GRPC\ContextInterface $ctx,
        MessageRequest $in
    ): MessageResponse {
        $response = new MessageResponse();
        $response->setSuccess(true);
        $response->setMessage("Received on topic: " . $in->getTopic());

        // echo "[gRPC] Message received on topic '{$in->getTopic()}': " .
        //     $in->getPayload() . PHP_EOL;

        return $response;
    }
}
