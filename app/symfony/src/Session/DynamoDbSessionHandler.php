<?php

namespace App\Session;

use AsyncAws\DynamoDb\DynamoDbClient;
use AsyncAws\DynamoDb\Input\GetItemInput;
use AsyncAws\DynamoDb\Input\PutItemInput;
use AsyncAws\DynamoDb\Input\DeleteItemInput;
use SessionHandlerInterface;

class DynamoDbSessionHandler implements SessionHandlerInterface
{
    private DynamoDbClient $client;
    private string $table;
    private int $lifetime;

    public function __construct(
        string $table = 'sessions',
        int $lifetime = 3600,
        ?string $region = null,
        ?string $endpoint = null
    ) {
        $this->table = $table;
        $this->lifetime = $lifetime;
        
        $config = [
            'region' => $region ?? $_ENV['AWS_REGION'] ?? 'eu-west-3',
        ];
        
        if ($endpoint) {
            $config['endpoint'] = $endpoint;
        }
        
        $this->client = new DynamoDbClient($config);
    }

    public function open($path, $name): bool
    {
        return true;
    }

    public function read($id): string|false
    {
        try {
            $result = $this->client->getItem(new GetItemInput([
                'TableName' => $this->table,
                'Key' => [
                    'session_id' => ['S' => $id],
                ],
                'ConsistentRead' => true,
            ]));

            $item = $result->getItem();
            if (empty($item)) {
                return '';
            }

            // Accéder aux valeurs via les getters appropriés
            if (isset($item['expires'])) {
                $expires = (int) $item['expires']->getN();
                if ($expires < time()) {
                    $this->destroy($id);
                    return '';
                }
            }

            return $item['data']->getS() ?? '';
        } catch (\Exception $e) {
            error_log('Session read error: ' . $e->getMessage());
            return '';
        }
    }

    public function write($id, $data): bool
    {
        try {
            $expires = time() + $this->lifetime;

            $this->client->putItem(new PutItemInput([
                'TableName' => $this->table,
                'Item' => [
                    'session_id' => ['S' => $id],
                    'data' => ['S' => $data],
                    'expires' => ['N' => (string) $expires],
                ],
            ]));

            return true;
        } catch (\Exception $e) {
            error_log('Session write error: ' . $e->getMessage());
            return false;
        }
    }

    public function destroy($id): bool
    {
        try {
            $this->client->deleteItem(new DeleteItemInput([
                'TableName' => $this->table,
                'Key' => [
                    'session_id' => ['S' => $id],
                ],
            ]));

            return true;
        } catch (\Exception $e) {
            error_log('Session destroy error: ' . $e->getMessage());
            return false;
        }
    }

    public function gc($maxLifetime): int|false
    {
        // DynamoDB TTL s'occupe du nettoyage automatiquement
        return 0;
    }

    public function close(): bool
    {
        return true;
    }
}
