#import "defs.typ": *
#import "links.typ": *

#language(
  name: "Ada",

  introduction: [
    Le langage Ada est crée à la fin des années 70 au sein de l'équipe
    CII-Honeywell Bull
    dirigé par Jean Ichbiah en réponse à un cahier des charges du
    département de la
    Défense des États-Unis. Le principe fût de créer un langage spécifiquement
    dédié aux systèmes
    temps réels
    ou embarqués requérant un haut niveau de sûreté.

    Le langage est standardisé pour la première fois en 1983 #cite(<ada1983>)
    sous le
    nom d'_Ada83_. La dernière norme ISO _Ada 2022_ a été publiée en 2023
    #cite(<ada2023>).
    Notons que la norme _Ada 2012_ est librement téléchargeable
    #cite(<ada2012>).

  ],

  paradigme: [
    Ada est un langage de programmation #paradigme[objet] et #paradigme[impératif].
    Depuis la norme _Ada 2012_, le paradigme #paradigme[contrat] a été ajouté au
    langage.
  ],

  numerique: [
      La langage #Ada a la particularité d'être très rigoureux sur l'utilisation
      des types arithmétiques. Il n'y a pas de conversion implicite
      et le compilateur va adapter la représentation des valeurs en fonction
      de la précision demandée:

      ```ada
      with Ada.Text_IO; use Ada.Text_IO;
      procedure Custom_Floating_Types is
        type T3  is digits 3;
        type T15 is digits 15;
        type T18 is digits 18;
      begin
        Put_Line ("T3  requires "
                  & Integer'Image (T3'Size)
                  & " bits");
        Put_Line ("T15 requires "
                  & Integer'Image (T15'Size)
                  & " bits");
        Put_Line ("T18 requires "
                  & Integer'Image (T18'Size)
                  & " bits");
      end Custom_Floating_Types;
      ```

      Ici, le programe affichera:
      ```
      T3  requires  32 bits
      T15 requires  64 bits
      T18 requires  128 bits
      ```

      Par ailleurs, le compilateur va automatiquement vérifier les potentiels
      débordements. Dans l'exemple suivant, on ajoute 5 à la
      valeur maximale d'un entier:

      ```ada
      procedure Main is
        A : Integer := Integer'Last;
        B : Integer;
      begin
        B := A + 5;
        --  This operation will overflow, eg. it
        --  will raise an exception at run time.
      end Main;
      ```
      et la compilation indiquera le débordement:
      ```
      main.adb:5:11: warning: value not in range of type "Standard.Integer" [enabled by default]
      main.adb:5:11: warning: Constraint_Error will be raised at run time [enabled by default]
      ```
      Ces vérifications sont également faites sur les sous-types définis par
      l'utilisateur.

      Cela ne signifie pas qu'il ne peut pas y avoir de débordement car les
      contrôles sont faits à des points particulier du programme et un
      débordement peut se produire dans un calcul intermédiaire entre deux
      points de contrôle. Toutefois, l'hygiène du langage permet de réduire
      significativement les erreurs de calculs.

      Pour un contrôle plus poussé des erreurs de calculs, il est nécessaire de
      passer par #spark qui permet de garantir statiquement des propriétés sur
      les calculs effectués.

      Enfin, il existe aussi des implémentations #mpfr et #gmp pour #Ada pour
      calculs dynamiques.
  ],

  assurances: [
    Par sa conception même, le langage #Ada est conçu pour offir un haut niveau
    de garanties et une grande part des erreurs de programmation peuvent être
    évitées en utilisant les mécanismes intrinsèques du langage.

    Naturellement, il est toujours possible d'avoir des erreurs mais l'espace
    dans lequel celles-ci peuvent vivre est plus étroit que le fossé permis par
    le C. Par ailleurs, cet espace est adressé par les analyses statiques
    disponibles.

  ],

  runtime: [

    Les outils d'analyse statique (corrects) pour #Ada sont:
    - #codepeer (ou GNAT SAS) ;
    - #polyspace ;
    - #spark Toolset.
    Un comparatif (non exhaustif) des trois outils est donné dans la
    @ada-static.

    #figure(

      table(
        columns: (auto, auto, auto, auto),
        [*Erreur*],                      [*CodePeer*], [*Polyspace*], [*SPARK Toolset*],
        [*Division par 0*],              [✓],       [✓],         [✓],
        [*Débordement de tampon*],       [✓],       [✓],         [✓],
        [*Déréférencement de NULL*],     [✓],       [?],         [],
        [*Dangling pointer*],            [],        [],         [],
        [*Data race*],                   [✓],       [],         [],
        [*Interblocage*],                [],        [],         [],
        [*Vulnérabilités de sécurité*],  [],        [],         [],
        [*Dépassement d'entier*],        [✓],       [✓],         [✓],
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
      ),
      caption: "Comparatif des outils d'analyse statique pour le langage Ada",
    ) <ada-static>

  ],

  wcet: [
    Les outils #rapidtime et #aiT cités dans la partie C supportent
    explicitement #Ada.
  ],

  pile: [
    #let gnatstack = link(
      "https://www.adacore.com/gnatpro/toolsuite/gnatstack",
      "GNATstack"
    )

    Les outils analysant l'exécutable peuvent le faire tout autant pour les
    programmes #Ada. Pour les outils ciblant spécifiquement #Ada, il y
    #gnatstack et #gnat. Pour le second, les options suivantes permettent de
    contrôler l'usage de la pile:
    - `-fstack-usage` qui produit une estimation de la taille maximale de la
      pile par fonction.
    - `-Wstack-usage=BYTES` qui produit un message d'avertissement pour les
      fonctions
      qui pourraient nécessiter plus de `BYTES` octets sur la pile.
  ],

  intrinseque: [

    *Typage*

    Le langage Ada dispose d'un système de typage riche et statiquement vérifié
    par le compilateur.
    Contrairement aux langages comme C ou C++, Ada est _fortement typé_ au sens
    qu'il ne fait pas de conversions implicites entre des types
    différents. Par exemple l'expression `2 * 2.0` produira une erreur de
    compilation car le type de `2` est `Integer` et le type de `2.0` est `Float`.

    En plus des habituels types scalaires (entiers, flottants, ...), des
    enregistrements et des énumérations, le langage dispose de l'abstraction
    de type et d'un système de sous-typage.

    Il est possible de construire un nouveau type à partir d'un autre type via
    la syntaxe `type New_type is new Old_type`. Par exemple le programme
    suivant:

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
    ne compilera pas car bien que `X` et `Y` aient la même représentation
    mémoire (des flottants), ils ne sont pas du même type.

    *Sous-typage*

    Ada dispose également d'une particularité qui lui permet de définir des
    sous-types arbitraires. Par exemple, si l'on veut un compteur
    dont on sait que les valeurs vont de 1 à 10, on peut définir le type
    correspondant :

    ```ada
    subtype Counter is Integer range 1 .. 10;
    ```

    *Contrats*

    Depuis la norme Ada 2012, il est possible d'ajouiter explicitement des
    _contrats_ sous forme de préconditions, postconditions et d'invariants.
    Par exemple la fonction suivante implémente la racine carrée entière
    qui n'est définie que pour les entiers positifs.

    ```ada
    function Isqrt (X : Integer) return Integer
    with
      Pre => X >= 0,
      Post => X = Isqrt'Result * Isqrt'Result
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
    Compilé avec l'option `-gnata` du compilateur #gnat, on obtiendra une
    erreur à l'exécution si on appelle cette fonction avec une valeur négative.

    On peut également spécifier des invariants pour des types dans les
    interfaces des _packages_. Par exemple, pour une implémentation des
    intervalles fermés, on peut garantir que l'unique représentant de
    l'intervalle vide est donné par le couple d'entiers `(0, -1)`.

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
    La fonction `Check`, dont l'implémentation n'est pas exposée dans
    l'interface,
    s'assure que le seul intervalle vide est l'intervalle `[0, -1]`. Une
    implémentation de cette interface pourrait être:

    ```ada
    package body Intervals is
      function Make (L : Integer; U : Integer) return Interval is
        (if U < L then (0, -1) else (L, U));

      function Min (X : Integer; Y : Integer) return Integer is
        (if X <= Y then X else Y);

      function Max (X : Integer; Y : Integer) return Integer is
        (if X <= Y then Y else X);

      function Inter (I : Interval; J : Interval) return Interval is
        Make (Max (I.Lower, J.Lower), Min (I.Upper, J.Upper));

      function Check (I : Interval) return Boolean is
        (I.Lower <= I.Upper or (I.Lower = 0 and I.Upper = -1));
    end Intervals;
    ```

    *Concurrence*

    Le langage Ada intègre dans sa norme des bibliothèques pour la
    programmation concurrentielle. Le concept de _tâche_ permet d'exécuter
    des applications en
    parallèle en faisant abstraction de leur implémentation. Une tâche peut
    ainsi
    être exécutée via un thread système ou un noyau dédié. Il est également
    possible de donner des propriétés aux tâches et de les synchroniser
    comme avec l'exemple du @ada-concurrence.

#figure(
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
    ```,
    caption: "Exemple de programmation concurrentielle en Ada",
) <ada-concurrence>

    *Temps réel*

    Le profile _Ravenscar_ est un sous-ensemble du langage Ada conçu pour les
    systèmes temps réel. Il a fait l'objet d'une standardisation dans _Ada 2005_.
    En réduisant les fonctionnalités liées aux multi-tâches, ce profile
    facilite en outre la vérification automatique des programmes.

  ],

  tests: [

    #let aunit = link("https://github.com/AdaCore/aunit", "AUnit")
    #let adatest95 = link(
      "https://www.qa-systems.fr/tools/adatest-95/",
      "Ada Test 95"
    )
    #let avhen = link("http://ahven.stronglytyped.org/", "Avhen")
    #let ldra = link("https://ldra.com/products/ldra-tool-suite/", "LDRA")
    #let vectorcastAda = link(
      "https://www.vector.com/int/en/products/products-a-z/software/vectorcast/vectorcast-ada/",
      "VectorCAST/Ada"
    )


    #let rtrt = link(
      "https://www.ibm.com/products/rational-test-realtime",
      "Rational Test RealTime"
    )

    Les différents outils de tests recensés pour #Ada sont inddiqués dans
    la @ada-test.

    #figure(
      table(
        columns: (auto, auto, auto, auto, auto),
        [*Outil*],               [*Tests*], [*Generation*], [*Gestion*], [_*mocking*_],
        [*#aunit*],              [U],       [+],          [✓],         [],
        [*#adatest95*],          [UI],      [++],            [✓],          [],
        [*#avhen*],              [U],       [+],            [✓],         [],
        [*#ldra*],               [UIC],     [+],            [✓],         [],
        [*#vectorcastAda*],      [UC],      [++],           [✓],           [✓],
        [*#rtrt*],               [UIC],     [],             [],           [],
      ),
      caption: [Comparaison des outils de tests pour le langage C],
    ) <ada-test>

    #aunit et #avhen sont des implémentations xUnit pour #Ada. Les fonctionnalités sont
    toujours les mêmes et permettent de décrire des suites de tests unitaires
    avec un systèmes d'assertion et du _tooling_ simplifiant la tâche. Comme
    pour les autres implémentations xUnit, un rapport au format JUnit est
    généré.

    #adatest95 et #ldra (TBrun) sont des outils commerciaux de génération de
    tests unitaire et d'intégration.
    Ils offrent un support pour l'automatisation et sont conformes aux
    exigences de test dans les standards de sûreté.

    #vectorcastAda est la version adaptée à #Ada de l'outil de génération de
    tests #vectorcast. Il permet de générer des tests unitaires, d'intégration
    et propose un support pour le _mocking_. Contrairement à #adatest95 et
    #ldra qui ne supportent que Ada95, #vectorcastAda supporte également les
    normes Ada 2005 et Ada 2012. L'outil semble spécialisé dans l'avionique et
    est conforme aux exigences de la DO-178B.

    #rtrt est un outil commercial de test unitaire et d'intégration pour les
    systèmes temps réel. Il procède par instrumentation du code source et
    génère des rapports de couverture de code. Il permet également de
    faire du profilage mais les informations
    sur la génération, la gestion et le _mocking_ ne sont pas clairement
    documentées.

  ],

  parsers: [

    #let aflex = link("https://github.com/Ada-France/aflex", "AFlex")
    #let ayacc = link("https://github.com/Ada-France/ayacc", "AYacc")

    #Ada est rarement employé pour l'écriture de compilateurs et il y a peu
    de support dans ce domaine. Il y a un équivalent de Lex/Yacc avec
    #aflex/#ayacc fournis par l'association Ada-France. #cocor permet également
    de générer des analyseurs syntaxiques pour #Ada.
  ],

  compilation: [
    Parmi tous les compilateurs Ada, nous listons uniquement ceux qui semblent
    maintenus et de qualité industrielle.

    #let ptcdobjada = link(
      "https://www.ptc.com/en/products/developer-tools/objectada",
      "PTC ObjectAda"
    )
    #let ptcapexada = link(
      "https://www.ptc.com/en/products/developer-tools/apexada",
      "PTC ApexAda"
    )
    #let gnatpro = link("https://www.adacore.com/gnatpro", "GNAT Pro")
    #let gnatllvm = link("https://github.com/AdaCore/gnat-llvm", "GNAT LLVM")
    #let gaoc = link(
      "https://www.ghs.com/products/ada_optimizing_compilers.html",
      "GreenHills Ada Optimizing Compiler")

    #let janusada = link(
      "http://www.rrsoftware.com/html/blog/ja-312-rel.html",
      "Janus/Ada"
    )

    #figure(

      table(
        columns: (auto, auto, auto, auto),
        [*Compilateur*], [*Plateformes*], [*Licence*], [
          *Normes*#footnote[
            Nous ne considérons ici que les trois normes ISO Ada95,
            Ada 2005 et Ada 2012.
          ]
        ],
        [#ptcdobjada], [Toutes],         [Propriétaire], [95, 2005, 2012],
        [GCC #gnat],   [Toutes],         [GPLv3+],       [95, 2005, 2012],
        [#gnatpro],    [Toutes],         [Propriétaire], [95, 2005, 2012],
        [#gnatllvm],   [Toutes],         [GPLv3+],       [?],
        [#gaoc],       [Windows, Linux], [Proprietaire], [],
        [#ptcapexada], [Linux],          [Propriétaire], [],
        [#janusada],   [Windows],        [Propriétaire], [95, 2005, 2012],
      )
    )

    Les compilateurs #gnat, #gnatpro et #janusada proposent également un mode
    Ada83 mais ne donnent pas de garantie quant au respect de ce standard.

    Le langage Ada a une longue tradition de validation des compilateurs. Ce
    processus de validation a fait l'objet en 1999 d'une norme
    ISO#cite(<adaconformity>).
    L'_Ada Conformity Assessment Authority_ (abrégée _ACAA_) est actuellement
    l'autorité en charge de produire un jeu de tests
    (_Ada Conformity Assessment Test Suite_) validant
    la conformité d'un compilateur avec les normes Ada. Elle propose la
    validation
    pour les normes Ada83 et Ada95 à travers des laboratoires tiers
    indépendants.

    En plus de cette validation, certains compilateurs ont fait l'objet de
    certifications pour la sûreté ou la sécurité. Ansi #gnatpro dispose des
    certifications de sûreté :
      - DO-178C ;
      - EN-50128 ;
      - ECSS-E-ST-40C ;
      - ECSS-Q-ST-80C ;
      - _ISO 26262_
    ainsi que des certifications de sécurité:
      - DO-326A/ED-202A ;
      - DO-365A/ED-203A.

  ],

  debug: [
    Tous les débugueurs basés sur l'analyse binaire (#gdb, #lldb, ...) sont
    compatibles avec #Ada.
  ],

  packages: [

    #let alire = link("https://alire.ada.dev/", "Alire")

    #alire (_Ada LIbrary REpository_) est un dépôt de bibliothèques Ada près à
    l'emploi. L'installation se fait via l'outil `alr` à la manière de
    `cargo` pour #Rust ou `opam` pour #OCaml. L'outil dispose d'environ
    460 _crates_.

    Techniquement, les gestionnaires de paquets agnostiques peuvent également
    gérer les bibliothèques #Ada mais aucun support spéficique n'est recensé
    au delà des paquets `alire` et `gnat` pour #nix.

  ],

  formel: [
    #spark est la partie formelle du langage #Ada qui lui ajoute la possibilité
    d'ajouter des propriétés sur le code (à la manière des contrats d'Ada 2012)
    et de les vérifier statiquement en les déchargeant sur des démonstrateurs
    SMT (#z3, #cvc4 et #altergo).
  ],

  communaute: [
    La communauté #Ada est structurée autour d'organismes qui promeuvent
    l'utilisation du langage dans la recherche et l'industrie.
    - *Ada Europe* est une organisation internationale promouvant l'utilisation
      d'Ada dans la recherche #cite(<adaeurope>).
    - *Ada Resource Association* (ARA) est une association qui
      promeut l'utilisation d'Ada dans l'industrie #cite(<adaic>).
    - *Ada - France* est une association loi 1901 regroupant des utilisateurs
      francophones d'#Ada #cite(<adafrance>).
    - _The AdaCore blog_ est un blog d'actualité autour du langage Ada maintenu par l'entreprise _AdaCore_ #cite(<adacoreblog>).

  ],

  metaprog: [
    Il n'y a pas de support connu pour la méta-programmation en #Ada.
  ],

  derivation: [
    Il n'y a pas de support connu pour la dérivation en #Ada.
  ],

  adherence: [
    Le langage Ada peut être utilisé dans un contexte de programmation
    _bare metal_.

    - _GNAT FSF_ permet l'utilisation de _runtime_ personnalisé,
    - _GNAT Pro_ est livré avec plusieurs _runtime_:
      - _Standard Run-Time_ pour les OS classiques (Linux, Windows, VxWorks et RTEMS),
      - _Embedded Run-Time_ pour les systèmes _bare metal_ avec le support des tâches,
      - _Light Run-Time_ pour développer des applications certifiables sur des machines ayant peu de ressources;
    - _GreenHills Ada Optimizing Compiler_ fournit plusieurs implémentations de
      _runtime_ pour des cîbles différentes #cite(<greenhillscompiler>),
    - _PTC_ distribue un _runtime_ pour _PTC ObjectAda_ pour VxWorks et LynxOS sur PowerPC.
    - _PTC ApexAda_ propose également un _runtime_ dans un contexte _bare metal_ pour l'architecture Intel X86-64 #cite(<apexada>).

    Notons enfin qu'une des force du langage est qu'en proposant dans sa norme
    une
    API pour la programmation concurrentielle et temps-réel, il permet de
    cibler
    plusieurs plateformes ou runtimes différents sans avoir à modifier le
    code source.

  ],

  interfacage: [
    Ada peut être interfacé avec de nombreux langages. Les bibliothèques standards
    contiennent des interfaces pour les langages C, C++, COBOL et FORTRAN. L'exemple
    ci-dessous est issu du standard d'Ada 2012:
    ```ada
    --Calling the C Library Function strcpy
    with Interfaces.C;
    procedure Test is
      package C renames Interfaces.C;
      use type C.char_array;
      procedure Strcpy (Target : out C.char_array;
                        Source : in  C.char_array)
          with Import => True, Convention => C, External_Name => "strcpy";
      Chars1 :  C.char_array(1..20);
      Chars2 :  C.char_array(1..20);
    begin
      Chars2(1..6) := "qwert" & C.nul;
      Strcpy(Chars1, Chars2);
    -- Now Chars1(1..6) = "qwert" & C.Nul
    end Test;
    ```

    Certains compilateurs proposent également d'écrire directement de
    l'assembleur
    dans du code Ada. Pour ce faire, il faut inclure la bibliothèque
    `System.Machine_Code`
    dont le contenu n'est pas normalisé par le standard. Par exemple,
    le compilateur #gnat
    propose une interface similaire à celle proposée par #gcc en langage C:

    ```ada
    with System.Machine_Code; use System.Machine_Code;

    procedure Foo is
    begin
      Asm();
    end Foo;
    ```

  ],

  critique: [
    #Ada ayant été conçu pour les systèmes critique, il est naturellement
    utilisé dans ce domaine. D'abord
    présent dans un cadre militaire, #Ada est utilisé, autre
    autres#cite(<adaprojectsummary>), dans les
    domaines du spatial, de l'aéronautique et du ferroviaire :
    - dans les lanceurs Ariane 4, 5 et 6;
    - le système de transmission voie-machine (TVM) développé par le groupe
      CSEE et utilisé sur les lignes ferroviaires TGV, le tunnel sous la
      manche, la High Speed 1 au Royaume-Uni ou encore la LGV 1 en Belgique.
    - Le pilote automatique pour la ligne 14 du métro parisien dans le cadre du
      projet METEOR (Métro Est Ouest Rapide) #cite(<meteorproject>).
    - La majorité des logiciels embarqués du Boeing 777 sont écrits en Ada.


  ]
)

