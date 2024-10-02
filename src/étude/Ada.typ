#import "defs.typ": *
#import "links.typ": *

#language(
  name: "Ada",

  introduction: [
    Le langage Ada est crée à la fin des années 70 au sein de l'équipe
    CII-Honeywell Bull
    dirigé par Jean Ichbiah pour répondre à un cahier des charges du
    département de la
    Défense des États-Unis. Il est largement utilisé dans des systèmes temps
    réels
    ou embarqués requérant un haut niveau de sûreté.

    Le langage est standardisé pour la première fois en 1983 #cite(<ada1983>)
    sous le
    nom d'_Ada83_. La dernière norme ISO _Ada 2022_ a été publiée en 2023
    #cite(<ada2023>).
    La norme _Ada 2012_ est librement téléchargeable #cite(<ada2012>).

  ],

  paradigme: [
    Ada est un langage de programmation #paradigme[objet] et #paradigme[impératif].
    Depuis la norme _Ada 2012_, le paradigme #paradigme[contrat] a été ajouté au
    langage.
  ],

  runtime: [

    - CodePeer
    - Polyspace (MathWorks)
    - SPARK Toolset

    #figure(

      table(
        columns: (auto, auto, auto, auto),
        [*Erreur*],                      [*CodePeer*], [*Polyspace*], [*SPARK Toolset*],
        [*Division par 0*],              [✓],       [✓],         [],
        [*Débordement de tampon*],       [✓],       [✓],         [],
        [*Déréférencement de NULL*],     [✓],       [?],         [],
        [*Dangling pointer*],            [],        [],         [],
        [*Data race*],                   [✓],       [],         [],
        [*Interblocage*],                [],        [],         [],
        [*Vulnérabilités de sécurité*],  [],        [],         [],
        [*Dépassement d'entier*],        [✓],       [✓],         [],
        [*Arithmétique flottante*],      [],        [],         [],
        [*Code mort*],                   [✓],       [✓],         [],
        [*Initialisation*],              [✓],       [✓],         [],
        [*Flot de données*],             [],        [],         [],
        [*Contrôle de flôt*],            [],        [],         [],
        [*Flôt de signaux*],             [],        [],         [],
        [*Non-interférence*],            [],        [],         [],
        [*Fuites mémoire*],              [],        [],         [],
        [*Double `free`*],               [],        [✓],         [],
        [*Coercions avec perte*],        [],        [],         [],
        [*Mémoire superflue*],           [],        [],         [],
        [*Arguments variadiques*],       [],        [],         [],
        [*Chaînes de caractères*],       [],        [],         [],
        [*Contrôle d'API*],              [],        [],         [],
      )
    )

    Sources:
    - La liste des _Common Weakness Enumeration_ (abrégée CWE) détectés par
      Polyspace: #cite(<polyspacecwe>)

  ],

  wcet: [
    - _RapiTime_ développé par _Rapita Systems_ permet l'analyse du _WCET_ en Ada #cite(<rapitime>).
    - _aiT WCET Analyzers_ développé par _AbsInt_ supporte l'analyse du _WCET_ en Ada pour de nombreuses combinaisons compilateur/processeur #cite(<aitwcet>).

  ],

  pile: [
    Nous considérons ici les logiciels capables via une analyse statique d'estimer
    la taille maximale occupée par la pile d'un programme Ada lors de son exécution.

    - GNATstack développé par AdaCore #cite(<gnatstack>).
    - Le compilateur _GNAT FSF_ propose deux options pour analyser l'usage de la pile:
    --`-fstack-usage` qui produit une estimation de la taille maximale de la pile par fonctions.
    -- `-Wstack-usage=BYTES` qui produit un message d'avertissement pour les fonctions
    qui pourraient nécessitées plus que `BYTES` octets sur la pile.
    Il est à noter que ces deux options fournissent
  ],

  intrinseque: [
    ==== Typage statique fort

    Le langage Ada est _statiquement typé_ et _fortement typé_. Par _statiquement typé_, nous entendons que les types sont vérifiés à la compilation.
    Contrairement à des langages comme _C_ ou _C++_, Ada est _fortement typé_,
    c'est-à-dire qu'il ne fait pas de conversions implicites entre des types
    différents. Par exemple l'expression `2 * 2.0` produira une erreur de compilation car le type de `2` est `Integer` et le type de `2.0` est `Float`.

    En plus des habituels types scalaires (entiers, flottants, ...), des enregistrements et des énumérations, le langage dispose de l'abstraction de type et d'un système de sous-typage.

    ===== Type abstrait
    Il est possible de construire un nouveau type à partir d'un autre type via la syntaxe `type New_type is new Old_type`. Par exemple le programme suivant:

    ```ada
    procedure Foo is
      type Kilos is new Float;
      type Joules  is new Float;

      X : Kilos;
      Y : constant Joules := 10.0;
    begin
      X := Y;
    end Foo;
    ```
    ne compilera pas car bien que `X` et `Y` aient la même représentation mémoire (des flottants), ils ne sont pas du même type.

    ===== Sous-typage

    (TODO)

    ==== Programmation par contrat

    Depuis la norme _Ada 2012_, le paradigme de _programmation par contrat_
    a été ajouté au langage. Par exemple la fonction suivante implémente la fonction _racine carrée entière_ qui n'est définie que pour les entiers positifs.

    ```ada
    function Isqrt (X : Integer) return Integer with
    Pre => X >= 0, Post => X = Isqrt'Result * Isqrt'Result
    is
      Z, Y : Integer := 0;
    begin
      if X = 0 or X = 1 then
        return X;
      else
        Z := X / 2;
        Y := (Z + X / Z) / 2;
        while Y < Z loop
          Z := Y;
          Y := (Z + X / Z) / 2;
        end loop;
        return Z;
      end if;
    end Isqrt;
    ```
    Compilé avec l'option `-gnata` du compilateur _GNAT_, on obtiendra une
    erreur à l'exécution si on appelle cette fonction avec une valeur négative.

    On peut également spécifier des invariants pour des types dans les interfaces
    des _packages_. Par exemple, pour une implémentation des intervalles fermés, on peut garantir que l'unique représentant de l'intervalle vide est donné par le couple d'entiers `(0, -1)`.
    ```ada
    package Intervals is
      type Interval is private
        with Type_Invariant => Check (Interval);

      function Make (L : Integer; U : Integer) return Interval;

      function Inter (I : Interval; J : Interval) return Interval;

      function Check (I : Interval) return Boolean;

      private
        type Interval is record
          Lower : Integer;
          Upper : Integer;
        end record;
    end Intervals;
    ```
    La fonction `Check`, dont l'implémentation n'est pas exposée dans l'interface,
    s'assure que le seul intervalle vide est l'intervalle `[0, -1]`. Une implémentation de cette interface pourrait être:

    ```ada
    package body Intervals is
      function Make (L : Integer; U : Integer) return Interval is
      (if U < L then (0, -1) else (L, U));

      function Min (X : Integer; Y : Integer) return Integer is
      (if X <= Y then X else Y);

      function Max (X : Integer; Y : Integer) return Integer is
      (if X <= Y then Y else X);

      function Inter (I : Interval; J : Interval) return Interval is
      (Max (I.Lower, J.Lower), Min (I.Upper, J.Upper));

      function Check (I : Interval) return Boolean is
      (I.Lower <= I.Upper or (I.Lower = 0 and I.Upper = -1));
    end Intervals;
    ```

    Nous avons volontairement laissé un bug dans la fonction `Inter` qui n'appelle pas le _smart constructor_ `Make` pour normaliser un éventuel intervalle vide. Cette erreur pourrait être détectée à l'exécution avec une entrée appropriée ou par un outil d'analyse statique qui utilise les contrats comme des annotations (par exemple _SPARK_).

    ==== Support multi-tâche

    Le langage Ada intègre dans sa norme des bibliothèques pour la programmation concurrentielle. Le concept de _tâche_ permet d'exécuter des applications en
    parallèle en faisant abstraction de leur implémentation. Une tâche peut ainsi
    être exécutée via un thread système ou un noyau dédié. Il est également possible de donner des prioriétés aux tâches et de les synchroniser.

    ```ada
    with Ada.Text_IO; Use Ada.Text_IO;

    procedure Hello_World is
      protected Counter is
        procedure Decr(X : out Integer);
        function Get return Integer;
      private
        Local : Integer := 20;
      end Counter;

      protected body Counter is
        procedure Decr(X : out Integer) is begin
          X := Local;
          Local := Local - 1;
        end Decr;

        function Get return Integer is begin
          return Local;
        end Get;
      end Counter;

      task T1;
      task T2;

      task body T1 is
        X : Integer;
      begin
        loop
          Counter.Decr(X);
          Put_Line ("Task 1: " & Integer'Image (X));
          exit when Counter.Get <= 1;
        end loop;
      end T1;

      task body T2 is
        X : Integer;
      begin
        loop
          Counter.Decr(X);
          Put_Line ("Task 2: " & Integer'Image (X));
          exit when Counter.Get <= 1;
        end loop;
      end T2;
    begin
      null;
    end Hello_World;
    ```

    ==== Traits temps réel

    Le profile _Ravenscar_ est un sous-ensemble du langage Ada conçu pour les
    systèmes temps réel. Il a fait l'objet d'une standardisation dans _Ada 2005_.
    En réduisant les fonctionnalités liées aux multi-tâches, ce profile
    facilite en outre la vérification automatique des programmes.

  ],

  tests: [
    Nous nous bornons ici aux logiciel de génération de tests et aux bibliothèques facilitant la gestion des tests unitaires.

    ==== Automatisation
    - LDRA TBrun
    - VectorCAST/Ada
    - GNATtest
    - AdaTEST 95
    - Rational Test RealTime (RTRT)

    ==== Test unitaire
    - Ahven
    - AUnit

  ],

  compilation: [
    Il existe de nombreux compilateurs Ada. Nous nous bornons ici à lister quelques compilateurs maintenus et de qualité industrielle.

    #figure(

      table(
        columns: (auto, auto, auto, auto, auto),
        [Compilateur], [Compagnie], [OSs], [Licence], [Normes#footnote[Nous ne considérons ici que les trois normes ISO _Ada95_, _Ada 2005_ et _Ada 2012_.]],
        [PTC ObjectAda], [PTC, Inc.], [Windows, Unix-like], [Propriétaire], [95, 2005, 2012],
        [GNAT FSF], [GNU Project], [Windows, Unix-like], [GPLv3+], [95, 2005, 2012],
        [GNAT Pro], [AdaCore], [Windows, Unix-like], [GPLv3+], [95, 2005, 2012],
        [GNAT LLVM], [AdaCore], [Windows, Unix-like], [GPLv3+], [?],
        [GreenHills Ada Optimizing Compiler], [Green Hills Software], [Windows, Unix-like], [Proprietary], [],
        [PTC ApexAda], [PTC, Inc.], [Unix-like], [Propriétaire], [],
        [SCORE Ada], [Symbolics, Inc.], [Symbolics Genera], [Propriétaire], [95],
        [Janus/Ada], [R.R. Software, Inc.], [Windows], [Propriétaire], [95, 2005, 2012],
      )
    )

    Les compilateurs _GNAT FSF_, _GNAT Pro_ et _Janus/Ada_ proposent également un mode _Ada 83_ mais
    ne donnent pas garantie quant au respect de ce standard.

    Le langage Ada a une longue tradition de validation des compilateurs. Ce
    processus de validation a fait l'objet en 1999 d'une norme ISO #cite(<adaconformity>).
    L'_Ada Conformity Assessment Authority_ (abrégée _ACAA_) est actuellement
    l'autorité en charge de produire un jeu de tests
    (_Ada Conformity Assessment Test Suite_) validant
    la conformité d'un compilateur avec les normes Ada. Elle propose la validation
    pour les normes Ada83 et Ada95 à travers des laboratoires tiers indépendants.

    En plus de cette validation, certains compilateurs ont fait l'objet de certifications pour la sûreté ou la sécurité:
    - _GNAT Pro_ dispose des certifications de sûreté suivant:
      - _DO-178C_, _EN-50128_, _ECSS-E-ST-40C_,_ECSS-Q-ST-80C_ et _ISO 26262_
      et des certifications de sécurité:
      - _DO-326A/ED-202A_ et _DO-365A/ED-203A_.

  ],

  debug: [
    Le débuggeur libre GDB fonctionne avec Ada et est généralement distribué avec GNAT.

  ],

  packages: [
    ALIRE (_Ada LIbrary REpository_) est un dépôt de bibliothèques Ada près à l'emploi. L'installation se fait via l'outil _alr_ inspiré de _Cargo_ en _Rust_ et _opam_ en _OCaml_.

  ],

  communaute: [
    - _Ada Europe_ est une organisation internationale promouvant l'utilisation
      d'Ada dans la recherche #cite(<adaeurope>).
    - _Ada Resource Association_ (abrégée _ARA_) est une association qui promeut l'utilisation d'Ada dans l'industrie #cite(<adaic>).
    - _Ada - France_ est une association loi 1901 regroupant des utilisateurs francophones d'Ada #cite(<adafrance>).
    - _The AdaCore blog_ est un blog d'actualité autour du langage Ada maintenu par l'entreprise _AdaCore_ #cite(<adacoreblog>).

  ],

  adherence: [
    Le langage Ada peut être utilisé dans un contexte de programmation _bare metal_,
    c'est-à-dire en l'absence d'un système d'exploitation complexe.

    - _GNAT FSF_ permet l'utilisation de _runtime_ personnalisé,
    - _GNAT Pro_ est livré avec plusieurs _runtime_:
      - _Standard Run-Time_ pour les OS classiques (Linux, Windows, VxWorks et RTEMS),
      - _Embedded Run-Time_ pour les systèmes _bare metal_ avec le support des tâches,
      - _Light Run-Time_ pour développer des applications certifiables sur des machines ayant peu de ressources;
    - _GreenHills Ada Optimizing Compiler_ fournit plusieurs implémentations de
      _runtime_ pour des cîbles différentes #cite(<greenhillscompiler>),
    - _PTC_ distribue un _runtime_ pour _PTC ObjectAda_ pour VxWorks et LynxOS sur PowerPC.
    - _PTC ApexAda_ propose également un _runtime_ dans un contexte _bare metal_ pour l'architecture Intel X86-64 #cite(<apexada>).

    Notons enfin qu'une dès force du langage est qu'en proposant dans sa norme une
    API pour la programmation concurrentielle et temps-réel, il permet de cibler
    plusieurs plateformes ou runtimes différents sans avoir à modifier le code source.

  ],

  interfacage: [
    Ada peut être interfacé avec de nombreux langages. Les bibliothèques standards
    contiennent des interfaces pour les langages C, C++, COBOL et FORTRAN. L'exemple
    ci-dessous est issu du standard d'_Ada 2012_:
    ```ada
    --Calling the C Library Function strcpy
    with Interfaces.C;
    procedure Test is
      package C renames Interfaces.C;
      use type C.char_array;
      procedure Strcpy (Target : out C.char_array;
                        Source : in  C.char_array)
          with Import => True, Convention => C, External_Name => "strcpy";
    This paragraph was deleted.
      Chars1 :  C.char_array(1..20);
      Chars2 :  C.char_array(1..20);
    begin
      Chars2(1..6) := "qwert" & C.nul;
      Strcpy(Chars1, Chars2);
    -- Now Chars1(1..6) = "qwert" & C.Nul
    end Test;
    ```

    Certains compilateurs proposent également d'écrire directement de l'assembleur
    dans du code Ada. Pour ce faire, il faut inclure la bibliothèque `System.Machine_Code`
    dont le contenu n'est pas normalisé par le standard. Par exemple, le compilateur _GNAT_
    propose une interface similaire à celle proposée par _GCC_ en langage C:

    ```ada
    with System.Machine_Code; use System.Machine_Code;

    procedure Foo is
    begin
      Asm();
    end Foo;
    ```

  ],

  critique: [
    Ada intégrant des fonctionnalités pertinentes dans un cadre critique, il a été
    abondamment utilisé dans de nombreux projets à haute exigence de sûreté. D'abord
    présent dans un cadre militaire, Ada est aujourd'hui utilisé par des entreprises
    publiques et privées. Nous ne retenons ici que quelques uns de ses nombreux succès:
    - Les fusées Ariana 4, 5 et 6.
    - Le système de transmission voie-machine (TVM) développé par le groupe CSEE et
    utilisé sur les lignes ferroviaires TGV, le tunnel sous la manche, la High Speed
    1 au Royaume-Uni ou encore la LGV 1 en Belgique.
    - Le pilote automatique pour la ligne 14 du métro parisien dans le cadre du projet
      _METEOR_ (Métro Est Ouest Rapide) #cite(<meteorproject>).
    - La majorité des logiciels embarqués du Boeing 777 sont écrits en Ada.

    Une liste plus fournis de logiciels critiques utilisant Ada avec quelques
    sources: #cite(<adaprojectsummary>).

  ]
)

