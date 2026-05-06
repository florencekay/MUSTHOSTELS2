<?php
require_once '../includes/config.php';
require_once '../includes/allocation.php';
requireLogin('operator');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $result = runBatchAllocation();
    setFlash('success', "Allocation complete! Allocated: {$result['allocated']}, Not allocated: {$result['rejected']}");
}

header('Location: ' . SITE_URL . '/operator/dashboard.php');
exit;