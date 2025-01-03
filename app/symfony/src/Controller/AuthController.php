<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class AuthController extends AbstractController
{
    #[Route('/login', name: 'app_login')]
    public function login(Request $request): Response
    {
        // Simuler une authentification simple
        if ($request->isMethod('POST')) {
            $username = $request->request->get('username');
            $password = $request->request->get('password');

            // Pour l'exemple, on accepte user/password
            if ($username === 'user' && $password === 'password') {
                // Stocker les données dans la session
                $request->getSession()->set('user', [
                    'username' => $username,
                    'roles' => ['ROLE_USER'],
                    'loginTime' => new \DateTime(),
                ]);

                return $this->redirectToRoute('app_dashboard');
            }

            $this->addFlash('error', 'Identifiants invalides');
        }

        return $this->render('auth/login.html.twig');
    }

    #[Route('/dashboard', name: 'app_dashboard')]
    public function dashboard(Request $request): Response
    {
        // Vérifier si l'utilisateur est connecté
        $user = $request->getSession()->get('user');
        if (!$user) {
            return $this->redirectToRoute('app_login');
        }

        return $this->render('auth/dashboard.html.twig', [
            'user' => $user,
        ]);
    }

    #[Route('/logout', name: 'app_logout')]
    public function logout(Request $request): Response
    {
        $request->getSession()->invalidate();
        return $this->redirectToRoute('app_login');
    }
}
