# Extension WanAR<!-- omit in toc -->

Cette extension regoupe des améliorations apportées à la gestion du recouvrement (Account Receivables). 
![Account Receivables](images/AccountReceivables.png)

> Ce n’est que l’une des extensions gracieusement mises à votre disposition (voir [Extensions | Wanamics](https://www.wanamics.fr/extensions-business-central/)).\
Vous pouvez donc en disposer librement dans le cadre de la licence open source qui vous est accordée (voir [[Licence Open Source | Wanamics](https://www.wanamics.fr/licence-open-source/)).


Voir aussi 
* [Collecte des soldes restants | Microsoft Learn](https://learn.microsoft.com/fr-ch/dynamics365/business-central/receivables-collect-outstanding-balances)
* [Comptabilité clients et recouvrement | Wanamics](https://www.wanamics.fr/comptabilite-clients-et-recouvrement/).
* [Configuration des niveaux de relance | Microsoft Learn](https://learn.microsoft.com/fr-fr/dynamics365/business-central/finance-setup-reminders#to-set-up-reminder-levels)

### Sommaire<!-- omit in toc -->
- [Prérequis](#prérequis)
- [Ecritures comptables client](#ecritures-comptables-client)
  - [Colonnes](#colonnes)
  - [Actions](#actions)
- [Relance](#relance)
- [Relance émise](#relance-émise)
- [Présentations](#présentations)
- [Impact sur le modèle de données](#impact-sur-le-modèle-de-données)
- [Fonctions connexes](#fonctions-connexes)

## Prérequis
Les fonctions ci-après s'appuient sur la gestion des relances de Business Central introduite avec la version V24 (2024 w1).\
A ce jour, cette fonctionnalité doit encore être activée manuellement (via  *Mise à jour des fonctionnalités : utilisez de nouveaux textes de communication pour les conditions de relance*).\
Elle sera *Automatiquement activée à partir de* la version 28 (2026 w1).

## Ecritures comptables client

### Colonnes

* **Nbre de relances** (champ calculé) : Nombre de **Ecriture relance** associées et accès au détail (DrillDown) correspondant (N°, date de la relance...)

* **Date dern. relance** : **Date comptabilisation** de la dernière relance émise (recherchée via les **Ecritures relance**** associées).

* **Retard (j)** : 
    - Si non lettrée : **Date lettrage** - **Date d'échéance** (donc négatif en cas de paiement avant l'échéance).
    - Sinon et échéance dépassée : **Date de travail** - **Date d'échéance**

### Actions

* **Paiement tardif** : n'affiche que les écritures dont la **Date lettrage** est postérieure à la **Date d'échéance**


## Relance
* Actions ligne
    * Ajout de **Afficher facture**


## Relance émise
* Actions ligne
    * Ajout de **Afficher facture**


## Présentations

* Modèle inspiré des présentations WanaDoc (en-tête et pied de page...)
* Ajout de quelques champs (préfixe wan  : wanCreatedByName, wanUserName...)


## Impact sur le modèle de données
Aucun 

## Fonctions connexes

* Optionnel : WanaDoc (MemoPad) pour faciliter la gestion des textes.
