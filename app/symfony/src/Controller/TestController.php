<?php

namespace App\Controller;

use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class TestController extends AbstractController
{
    #[Route('/api/test', name: 'api_test', methods: ['GET'])]
    public function index(): JsonResponse
    {
        error_log('Entering index method');
        $response = new JsonResponse([
            'message' => 'Hello from Bref PHP!',
            'timestamp' => time(),
        ]);
        error_log('Response created: ' . json_encode($response->getContent()));
        return $response;
    }

    #[Route('/test', name: 'app_test')]
    public function indexx(LoggerInterface $logger): Response
    {
        $logger->info('Début du traitement de la route /test');
        $logger->info('Request URI: ' . $_SERVER['REQUEST_URI'] ?? 'non défini');
        $logger->info('Request Method: ' . $_SERVER['REQUEST_METHOD'] ?? 'non défini');
        
        return $this->render('test/index.html.twig', [
            'title' => 'Test Page',
            'message' => 'Cette page fonctionne !',
            'timestamp' => time(),
            'features' => [
                'Symfony 6.3',
                'PHP 8.2',
                'Asset Mapper',
                'Bootstrap 5.3'
            ]
        ]);
    }

}
