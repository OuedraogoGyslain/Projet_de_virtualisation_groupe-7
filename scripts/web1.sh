#!/bin/bash

# S'assure que le répertoire web existe AVANT d'écrire dedans
sudo mkdir -p /var/www/html

# Active et démarre Apache2 (ajout d'un update et install si nécessaire)
sudo apt-get update -y
sudo apt-get install -y apache2

sudo systemctl enable apache2
sudo systemctl start apache2

# Crée le fichier index.html avec le contenu HTML
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
            justify-content: flex-start;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .titre-container {
            width: 100%;
            height: 60px;
            overflow: hidden;
            position: relative;
            margin-top: 40px;
            background-color: #6B4C3B;
            box-shadow: 0 4px 8px rgba(107, 76, 59, 0.5);
            border-radius: 10px;
        }

        .titre-defilant {
            position: absolute;
            white-space: nowrap;
            font-size: 2em;
            color: white;
            top: 50%;
            transform: translateY(-50%);
            left: 100%;
            animation: defilement 15s linear infinite;
            font-weight: bold;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
        }

        @keyframes defilement {
            0% {
                left: 100%;
            }
            100% {
                left: -100%;
            }
        }

        .inscription-message {
            margin-top: 20px;
            font-size: 1.2em;
            color: #222;
            text-align: center;
            width: 100%;
            font-weight: bold;
            background-color: #D9B99B;
            padding: 10px 0;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(217, 185, 155, 0.5);
        }

        form {
            background: #f9fbff;
            padding: 25px 30px;
            border-radius: 15px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            min-width: 320px;
            margin-top: 30px;
            transition: background-color 0.3s ease;
        }

        form:hover {
            background-color: #e6f0ff;
        }

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #aaa;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus, input[type="email"]:focus {
            border-color: #6B4C3B;
            outline: none;
            box-shadow: 0 0 8px rgba(107, 76, 59, 0.5);
        }

        input[type="submit"] {
            margin-top: 15px;
            background-color: #6B4C3B;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #54392d;
        }
    </style>
</head>
<body>
    <div class="titre-container">
        <h1 class="titre-defilant">BIENVENU SUR LA PAGE OFFICIELLE DE NOTRE SITE WEB1</h1>
    </div>

    <div class="inscription-message">VEUILLEZ VOUS INSCRIRE</div>

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

# Redémarre Apache pour appliquer les modifications
sudo systemctl restart apache2
