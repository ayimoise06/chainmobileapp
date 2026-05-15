# Mode Administrateur (Options pour le Jury)

Pour administrer la plateforme (Approuver des producteurs, voir tous les lots, configurer les alertes web3), il y a deux solutions viables.

## Solution 1: FireCMS (Solution Recommandée)
Au lieu de recréer tous les affichages et tableaux depuis zéro, le marché utilise des "Headless CMS" greffés directement sur Firebase.
- Il suffit de se connecter sur `https://firecms.co/`
- Faire "Lier mon projet Firebase".
- Automatiquement, toute votre base de données devient un panel super élégant (avec filtres, imports Excel, création d'utilisateurs).

## Solution 2: Écran d'administration (Application Interne)
Actuellement, dans l'application `lib/main.dart` :
- Un paramètre fictif `profile?['role'] = 'Producteur Agrée'` est affiché sur l'écran "Profil".
- Pour séparer les vues, vous pouvez faire une vérification dans Firebase, et ne montrer le bouton "Nouvelle Publication Web3" *uniquement* à la condition : `if (role == 'admin')`.
