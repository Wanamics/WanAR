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
- [Présentations](#présentations)
- [Envoyer par e-mail](#envoyer-par-e-mail)
- [Impact sur le modèle de données](#impact-sur-le-modèle-de-données)
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

* Ajout de **Afficher facture**


## Relance émise
  **Actions ligne**

* Ajout de **Afficher facture**


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
**Table Reminder Email** 
* Ajout du champ **wan Body text** (*Corps du texte (suite)*)
## Outils
* Le traitement **Remove Beginning/Ending Lines** (URL + ?Report=87190) permet de supprimer les lignes de texte de début/fin sur les relances émises (pour éviter la redondance avec le corps du message.)\


## Fonctions connexes

* Optionnel : WanaDoc (MemoPad) pour faciliter la gestion des textes.
