<?php

namespace App\Services;

use Spiral\RoadRunner\GRPC\ContextInterface;
use Spiral\RoadRunner\GRPC\ServiceInterface;
use Messages\MessageRequest;
use Messages\MessageResponse;

interface MessageServiceInterface extends ServiceInterface
{
    public const NAME = "messages.MessageService";

    public function SendMessage(
        ContextInterface $ctx,
        MessageRequest $in
    ): MessageResponse;
}
