# Extension WanAR

Cette extension regoupe des améliorations apportées à la gestion du recouvrement (Account Receivables). 

![Account Receivables](images/AccountReceivables.png)


Voir aussi 
* [Collecte des soldes restants | Microsoft Learn](https://learn.microsoft.com/fr-ch/dynamics365/business-central/receivables-collect-outstanding-balances)
* [Comptabilité clients et recouvrement | Wanamics](https://www.wanamics.fr/comptabilite-clients-et-recouvrement/).
* [Configuration des niveaux de relance | Microsoft Learn](https://learn.microsoft.com/fr-fr/dynamics365/business-central/finance-setup-reminders#to-set-up-reminder-levels)

**Sommaire**
- [Prérequis](#prérequis)
- [Ecritures comptables client](#ecritures-comptables-client)
- [Relance](#relance)
- [Relance émise](#relance-émise)
- [Relance par facture](#relance-par-facture)
- [Présentations](#présentations)
- [Envoyer par e-mail](#envoyer-par-e-mail)
- [Impact sur le modèle de données](#impact-sur-le-modèle-de-données)
- [Outils](#outils)
- [Fonctions connexes](#fonctions-connexes)

## Prérequis
Les fonctions ci-après s'appuient sur la gestion des relances de Business Central introduite avec la version V24 (2024 w1).\
A ce jour, cette fonctionnalité doit encore être activée manuellement (via  *Mise à jour des fonctionnalités : utilisez de nouveaux textes de communication pour les conditions de relance*).\
Elle sera *Automatiquement activée à partir de* la version 28 (2026 w1).

## Ecritures comptables client

**Colonnes**

* **Nbre de relances** (champ calculé) : Nombre de **Ecriture relance** associées et accès au détail (DrillDown) correspondant (N°, date de la relance...)

* **Date dern. relance** : **Date comptabilisation** de la dernière relance émise (recherchée via les **Ecritures relance** associées).

* **Retard (j)** : 
    - Si non lettrée : **Date lettrage** - **Date d'échéance** (donc négatif en cas de paiement avant l'échéance).
    - Sinon, si échéance dépassée : **Date de travail** - **Date d'échéance**

**Actions**

* **Paiement tardif** : n'affiche que les écritures dont la **Date lettrage** est postérieure à la **Date d'échéance**

## Relance

**Actions ligne**

* +**Afficher facture**


## Relance émise
**Actions ligne**

* +**Afficher facture**

## Relance par facture

Si un même **Client** Business Central en regroupe plusieurs (voir [Clients B2C, Tous pour un, un pour tous](
https://www.wanamics.fr/clients-b2c-tous-pour-un-un-pour-tous/)), une relance unique n'aurait pas de sens.

* Une **Condition relance** définie à cet effet est attribuée au client concerné.
* Elle est complétée d'un indicateur **Par facture**.
* Dès lors, le traitement **Créer relance** génère une relance discincte pour chaque facture.
* L'adresse e-mail (non définie pour le client) est alors extraite de la facture concernée.

**Remarque**
* Il est possible d'associer au client concerné (ex : client générique B2C), une **Présentation document** spécifique (en particulier pour une **Disposition du corps du message** et/ou une **Disposition de la pièce jointe à un e-mail** personnalisée). Cependant **Envoyer vers e-mail** ne doit pas être renseigné, faute de quoi l'adresse e-mail de la facture ne serait pas prise en compte.

## Présentations

* Modèle inspiré des présentations WanaDoc (en-tête et pied de page...)
* Ajout de quelques champs (préfixe wan) : 
  * Issued Reminder Header (Cf. WanaDoc)
    * wanCompanyAddress : adresse de la société
    * wanCompanyContactInfo : coordonnées de contact de la société
    * wanCompanyLegalInfo : informations légales de la société
    * wanToAddress : adresse du destinataire
  * Integer (Cf. WanaDoc) :
    * wanCompanyInfoPicture : Logo de la société
  * Issued Reminder Line
    * wanDescription : **Type Document** et **N° document** si facture (échue ou non), **Description** sinon.
    * wanOriginalAmtBWZ : Montant initial (vide si nul)
    * wanRemainingAmtBWZ : Montant ouvert (vide si nul)
  * LetterText
    * wanBodyText : **Corps du message (suite)** voir [Envoyer par e-mail](#envoyer-par-e-mail)
    * wanCreatedByName : Nom de l'utilisateur ayant émis la relance
    * wanUserName : Nom de l'utilisateur courant

## Envoyer par e-mail
* Comme pour la procédure automatisée, les factures concernées sont également jointes au mail de relance pour la procédure manuelle.
* Le **Corps du message (suite)** similaire au **Corps du message** permet de dissocier le corps du message respectivement après ou avant le détail des lignes.\
 Il vient donc le compléter la page **Communication** associée à **Condition de paiement** ou **Niveau relance**. 

**Remarques**

* Pour éviter de joindre le document de relance (ayant peu d'intérêt si le corps du message reprend les mêmes informations), il suffit de ne pas cocher **Utiliser comme pièce jointe** pour la **Sélection des états : Rappel/Intérêts de retard** et de laisser vide le **Nom du fichier** en **Configuration des conditions de relance** (par **Niveau** et **Code langue** le cas échéant).
* Le message mentionne les factures en retard mais pas celles non échues (la page d'options n'étant pas proposée, l'option **Afficher montant échus** ne peut être sélectionnée). 

## Impact sur le modèle de données

* **Table Reminder terms**
  * +**wanAR Per Invoice**

* **Table Reminder Email** 
  * +**wan Body text** (*Corps du texte (suite)*)

* **Table Reminder Header**
  * +**WanAR Sell-to E-Mail**

* **Table Issued Reminder Header**
  * +**WanAR Sell-to E-Mail**

## Outils
* Le traitement **Remove Beginning/Ending Lines** (URL + ?Report=87190) permet de supprimer les lignes de texte de début/fin sur les relances émises (pour éviter la redondance avec le corps du message.)\


## Fonctions connexes

* Optionnel : WanaDoc (MemoPad) pour faciliter la gestion des textes **Lignes début** et **Lignes fin**.
