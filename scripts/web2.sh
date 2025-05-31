# -*- mode: ruby -*-
# vi: set ft=ruby :
#!/bin/bash

#!/bin/bash

#!/bin/bash

# Mettre à jour et installer Apache
sudo apt update
sudo apt install -y apache2

# Créer une page HTML personnalisée
sudo tee /var/www/html/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Site Web1</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #f0f0f0, #d6e4ff);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        h1 {
            animation: fadeIn 2s ease-in-out;
            color: #333;
            text-align: center;
        }

        form {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            animation: slideIn 1.5s ease-out;
            min-width: 300px;
        }

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        input[type="submit"] {
            margin-top: 15px;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }
    </style>
</head>
<body>
    <h1>VOUS ETES SUR LA PAGE OFFICIELLE DE NOTRE SITE WEB2- BIENVENU !</h1>
    <form method="POST">
        <label for="prenom">Prénom :</label><br>
        <input type="text" id="prenom" name="prenom" required><br>

        <label for="nom">Nom :</label><br>
        <input type="text" id="nom" name="nom" required><br>

        <label for="email">Adresse e-mail :</label><br>
        <input type="email" id="email" name="email" required><br>

        <input type="submit" value="Envoyer">
    </form>
</body>
</html>
EOF

# Activer et redémarrer Apache
sudo systemctl enable apache2
sudo systemctl restart apache2
