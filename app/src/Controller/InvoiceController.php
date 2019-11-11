<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

/**
 * Class InvoiceController
 * @package App\Controller
 * @Route("invoice")
 */
class InvoiceController extends AbstractController
{
    /**
     * @Route("/insert", name="insert")
     */
    public function insert()
    {
        return $this->json([
            'message' => 'Welcome to your new controller!',
            'path' => 'src/Controller/InvoiceController.php',
        ]);
    }
}
