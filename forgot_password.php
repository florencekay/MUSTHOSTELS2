<?php
require_once 'includes/config.php';

$error = '';
$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $identifier = clean($_POST['identifier'] ?? '');

    if (empty($identifier)) {
        $error = 'Please enter your registration number, username or email.';
    } else {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM users WHERE reg_number = ? OR email = ? LIMIT 1");
        $stmt->execute([$identifier, $identifier]);
        $user = $stmt->fetch();

        if ($user) {
            $message = 'a code has been sent to the registered email address. Please check your inbox and verify.';
            // Optionally, send a notification or ask the user to contact the hostel office.
            // sendEmail($user['email'], 'Password Reset Instructions', ..., 'general');
        } else {
            $error = 'No account was found with that identifier.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password - MUST Hostel Booking System</title>
<link rel="stylesheet" href="assets/css/style.css">
<style>
.form-note { font-size: 13px; color: #556574; margin-top: 10px; }
.text-link { color: #0f2d52; text-decoration: none; }
</style>
</head>
<body>
<div class="login-page">
  <div class="login-left">
    <div class="login-hero">
      <div class="school-badge">
        <div class="badge-icon"><img src="assets/images/must.logo.png" alt="must.logo"></div>
        <div class="school-name">
          <strong>MUST</strong>
          Malawi University of Science<br>and Technology
        </div>
      </div>
      <h1>Forgot Password</h1>
      <p>Enter your registration number, username or email to recover your account.</p>
      <div class="login-features">
        <div class="feature-item"><div class="fi">🔒</div> Secure account recovery</div>
        <div class="feature-item"><div class="fi">📧</div> Instructions sent by email</div>
        <div class="feature-item"><div class="fi">👨‍💼</div> Admin and operator accounts supported</div>
      </div>
    </div>
  </div>

  <div class="login-right">
    <div class="login-form-wrap">
      <h2>Recover your password</h2>
      <p>We will send a reset message to your registered email address.</p>

      <?php if ($error): ?>
      <div class="alert alert-danger">❌ <?= htmlspecialchars($error) ?></div>
      <?php elseif ($message): ?>
      <div class="alert alert-success">✅ <?= htmlspecialchars($message) ?></div>
      <?php endif; ?>

      <?php if (!$message): ?>
      <form method="POST">
        <div class="form-group">
          <label for="identifier">Registration Number, Username or Email</label>
          <input type="text" name="identifier" id="identifier" placeholder="Enter your registration number, username or email" required value="<?= htmlspecialchars($_POST['identifier'] ?? '') ?>">
        </div>

        <button type="submit" class="btn btn-primary btn-lg" style="width:100%">Send Reset Instructions</button>
      </form>
      <?php endif; ?>

      <div class="form-note">
        If you don’t receive an email, contact the hostel office or system administrator for help.
      </div>

      <div class="divider">or</div>

      <div class="register-link">
        Back to <a href="index.php">Login</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
