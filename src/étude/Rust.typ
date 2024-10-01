#import "defs.typ": *
#import "links.typ": *


#language(
  name:"Rust",

  introduction: [
    Rust est un langage de programmation créé par Graydon Hoare en 2006,
    soutenu par la fondation Mozilla à partir de 2009, et dont la première
    version stable fût publiée en 2015. Le projet est depuis indépendant de
    Mozilla et soutenu par sa propre entité légale: la fondation Rust. Conçu
    comme un successeur aux langages C et C++, Rust cherche à concillier
    sûreté, performance et correction du code concurent. Il est souvent utilisé
    pour des applications systèmes, des logiciels embarqués, des navigateurs et
    des applications web.

    Il n'existe pas à l'heure actuelle de standard du langage, mais deux
    projets dans ce sens sont à citer:
    1. Les entreprises AdaCore et Ferrous Systems ont développé une version
    qualifiée du compilateur standard Rust, nommée
    #link("https://ferrocene.dev/en/")[Ferrocene], certifiée ISO26262 (ASIL D)
    et IEC 61508 (SIL 4) pour les plateformes x86 et ARM. Celle-ci est mise à
    jour tous les trois mois, soit toutes les deux à trois versions de Rust.
    <ferrocene>
    2. La fondation Rust a lancé un projet de rédaction d'une spécification, et
    recruté en ce sens. Ce projet semble sérieux et devrait aboutir a une
    spécification qui serait mise à jour à chaque parution d'une nouvelle
    version du compilateur (toutes les six semaines). Contrairement à la
    specification de Ferrocene, qui n'est pas un standard du langage mais se
    borne à décrire le fonctionnement d'un compilateur donné, la specification
    proposée par la fondation serait officielle et pourrait à terme aboutir à
    un standard.

    Il existe de plus un guide #cite(<anssi-rust>) édité par l'ANSSI pour le
    développement d'applications sécurisées en Rust.
  ],

  paradigme: [
    Rust est un langage multi-paradigme qui permet la programmation impérative,
    fonctionnelle, et (de manère plus limitée) orientée objet.

    Pour illuster l'aspect multi paradigmes, considérons l'exemple d'un code
    qui prend en entrée une liste de chaînes de caractères représentant des
    entiers et compte combien sont plus petits que 10.

    Dans un style fonctionnel:

    #figure(
    ```rust
    fn count_smaller_than_10(l: &[&str]) -> usize {
        l.iter()
            .filter_map(|s| s.parse::<i32>().ok())
            .filter(|&x| x < 10)
            .count()
    }
    ```
    )

    Dans un style impératif

    #figure(
    ```rust
    fn count_smaller_than_10(l: &[&str]) -> usize {
        let mut count = 0;
        for s in l {
            if let Ok(n) = s.parse::<i32>() {
                if n < 10 {
                    count += 1;
                }
            }
        }
        count
    }
    ```
    )

    #todo[Exemple POO ?]

  ],


  model_intro: [
    Eût égard à la relative jeunesse du langage, les outils de vérifications et
    de modélisation autour de Rust sont exclusivement des projets de recherche,
    en grande majorité académiques. Il est néanmoins remarquable qu'un langage
    si jeune bénéficie d'autant d'initiatives autour de ces sujets, signe d'un
    engoument certain et d'un intérêt potentiel pour des applications aux
    fortes contraintes de sûreté.
  ],

  runtime: [
    #link("https://github.com/endorlabs/MIRAI")[Mirai] est un interpréteur
    abstrait pour la représentation de niveau intermédaire du compilateur Rust.
    Il peut identifier certaines classes d'erreurs sans annotation, et
    également vérifier des annotations de programmes. Enfin, il peut servir à
    réaliser une _taint analysis_ ainsi que de la vérification d'éxécution en
    temps constant.
  ],

  wcet: [
    Il n'existe à ce jour pas d'outil sur étagère permettant de faire de
    l'analyse WCET de programmes spécifiquement Rust. Néanmoins, les outils
    fonctionnant sur du code assembleur peuvent être utilisés.
  ],

  pile: [
    Il n'existe à ce jour pas d'outil sur étagère permettant de faire de
    l'analyse de taille de pile de programmes Rust.
  ],

  numerique: [
    Il n'existe à ce jour pas d'outil sur étagère permettant de faire de
    l'analyse de qualité numérique statique en Rust.

    Il existe néanmoins plusieurs bibliothèques permettant de travailler avec
    plus de précision qu'avec des flottants 32 ou 64 bits. Certaines permettent
    du calcul à virgule fixe (#crate("bigdecimal"), #crate("rust_decimal")),
    des entiers de taille arbitraire(#crate("num"), #crate("ruint"), #crate
    ("rug")), des fractions (#crate("num"), #crate("rug")) ou des flottants de
    précision arbitraire (#crate("rug"), basé sur #mpfr).

    #todo[gmp-mpfr-sys ?]
  ],

  formel: [
    Il existe certains outils de méta-formalisation pour Rust, il s'agit
    d'outils académiques et aucun ne bénéficie d'un support commercial. À la
    lecture de leurs documentations disponibles et sans les tester, il apparaît
    difficile d'en recommander un en particulier.

    ==== Creusot

    #link("https://github.com/creusot-rs/creusot")[Creusot] est un outil de
    vérification déductive de code Rust. Il a son propre langage de
    specification nommé pearlite. Il traduit le code Rust et sa specification
    pearlite en code WhyML, utilisé ensuite par l'outil Why3. A ce jour, il a
    été utilisé pour vérifier formellement un SAT solver, CreuSAT.

    ==== Flux

    #link("https://flux-rs.github.io/flux/")[Flux] augmente Rust en lui
    rajoutant des types par rafinement. Il a également son propre langage de
    spécification, qui ne porte pas de nom. Il transforme ces types en Clauses
    de Horn Contraintes (CHC) et utilise directement le solver #z3 pour les
    résoudre.

    ==== Aenas

    #link("https://github.com/AeneasVerif/aeneas")[Aenas] et
    #link("https://github.com/AeneasVerif/charon")[Charon] sont deux outils,
    développés dans
    le cadre du même projet. Ils permettent de traduire du code Rust vers
    différents langages de spécification formelle afin de pouvoir écrire des
    preuves dessus. Les langages de preuve supportés sont F\*, Coq, HOL4 et
    LEAN.

    ==== Verus

    #link("https://github.com/verus-lang/verus")[Verus] permet également
    d'ajouter des spécifications à du code Rust, et de vérifier qu'elles sont
    satisfaites pour toute execution possible du programme. Il s'appuie
    directement sur le solveur SMT #z3.
  ],

  intrinseque: [
    Là où Rust prête le flanc à la critique par le manque de maturité des
    outils de vérification existants, il se rattrape par le nombre de garanties
    intrinsèquement proposées par le langage.

    ==== Des erreurs explicites

    En Rust, les erreurs sont rendues explicites dans les types de retour, et
    le compilateur signale lorsque l'on a omis de vérifier une potentielle
    valeur d'erreur. Par exemple pour cette fonction qui vérifie si un fichier
    fait moins de 100 kilo-octets, le type de retour
    `Result<bool, std::io::Error> ` indique qu'il s'agit d'un booléen dans le
    cas normal ou potentiellement d'une erreur d'IO.

    ```rust
    fn file_is_less_than_100kb(path: impl AsRef<Path>) -> Result<bool, std::io::Error> {
        let path = path.as_ref();
        let res = path.exists() &&
                  path.is_file() &&
                  std::fs::metadata(path)?.len() < 1024 * 100;
        Ok(res)
    }
    ```

    On ne peut pas accéder à la valeur booléenne sans vérifier l'erreur: le
    code ci-dessous donne une erreur de compilation.

    ```rust
    fn main() {
      if file_is_less_than_100kb("user.txt") {
        println!("user.txt is missing")
      }
    }
    ```

    ```
    error[E0308]: mismatched types
      --> src/main.rs:12:6
      |
    12 |   if file_is_less_than_100kb("user.txt") {
      |      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected `bool`, found `Result<bool, Error>`
      |
      = note: expected type `bool`
                  found enum `Result<bool, std::io::Error>`
    help: consider using `Result::expect` to unwrap the `Result<bool, std::io::Error>` value, panicking if the value is a `Result::Err`
      |
    12 |   if file_is_less_than_100kb("user.txt").expect("REASON") {
      |                                          +++++++++++++++++

    For more information about this error, try `rustc --explain E0308`.
    ```

    De même si l'on oublie de vérifier qu'une fonction uniquement à effet de
    bord n'a pas retourné d'erreur:

    ```rust
    fn write(path: impl AsRef<Path>, content: &str) -> Result<(), std::io::Error> {
        std::fs::write(path, content)
    }

    fn main() {
        write("user.txt", "John Smith");
    }
    ```

    on obtient le warning:

    ```
    warning: unused `Result` that must be used
    --> src/main.rs:8:5
      |
    8 |     write("user.txt", "John Smith");
      |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      |
      = note: this `Result` may be an `Err` variant, which should be handled
      = note: `#[warn(unused_must_use)]` on by default
    help: use `let _ = ...` to ignore the resulting value
      |
    8 |     let _ = write("user.txt", "John Smith");
      |     +++++++
    ```

    ==== La sûreté mémoire sans Glanneur de Cellules

    Rust dispose d'un mécanisme innovant de gestion de la mémoire par régions
    qui permet de garantir la sûreté mémoire au moment de le compilations, et
    sans avoir recours à un _runtime_ incluant un glanneur de cellules.
    Celui-ci, lié au système d'_ownership_ permet d'éviter les erreurs
    suivantes:

    - _use after free_
    - _data races_
    - _dangling pointers_
    - erreurs liés à l'_aliasing_ de pointeurs

  ],

  tests: [
    Il n'existe pas de générateur de tests pour des programmes Rust. Le langage
    inclus par défault un cadre de test classique mais limité, qui ne permet
    pas la génération de rapports de qualification. La librairie
    #link("https://docs.rs/mockall/latest/mockall/")[mockall] permet de faire
    du _mock_ pour les tests.
  ],

  compilation: [
    Hormis le compilateur Ferrocene mentionné en début de section page
    #pageref(<ferrocene>) qui n'est autre qu'une version qualifiée du
    compilateur standard (nommé `rustc`), il n'existe aujourd'hui pas de
    compilateur alternatif utilisable.

    On peut néanmoins mentionner les projets suivants:
    1. #link("https://rust-gcc.github.io/")[*gccrs*] vise à développer un
      _font-end_ Rust pour GCC. L'ensemble formé par ce front-end développé _de
      novo_ et GCC serait alors un compilateur entièrement différent de `rustc`.
    2. Deux projets visent à développer un backend alternatif à LLVM pour
      `rustc`:
      #set enum(numbering: "a.")
      + #link("https://github.com/rust-lang/rustc_codegen_gcc")[*rust codegen
      gcc*] branche le backend de GCC au frontend de rustc. Cela permettrait de
      supporter les plateformes déjà supportées par GCC mais n'offre pas une
      impélmentation entièrement indépendante.
      + #link("https://github.com/rust-lang/rustc_codegen_cranelift")[*rust
      codegen cranelift*] branche cranelift sur le frontend de rustc afin de
      permettre des temps de compilation plus rapides en mode dit _debug_
      (c'est à dire sans les optimisations). Idem quant à l'indépendence.

  ],

  debug: [
    Le langage Rust supporte officiellement GDB, LLDB et WinDbg/CDB.
  ],

  metaprog: [
    Rust dispose d'un riche système de macros, dit hygiénique car il évite les
    collisions. Ce système est largement utilisé, notamment pour implémenter
    automatiquement certaines méthodes sur des types (mécanisme de `derive`).

    #todo[Exemple ?]
  ],

  parsers: [
    Rust dispose de plusieurs outil d'écriture de parseurs. Il existe des
    librairies de combinateurs de parseurs, qui ne génèrent pas de code, mais
    également des générateurs de pareurs à proprement parler. Cinq sont à
    retenir.

    / #crate("Pest"): est un générateur de parseur basé sur les _Parsing
    Expression Grammars (PEG)_, apprécié pour sa simplicité. Il ne génère des
    parseurs que pour Rust.
    / #crate("LALRPOP"): est un générateur de parseur qui se donne pour but
    premier d'être facilement utilisable. Il vise à permettre d'écrire des
    grammaires succintes, compactes et lisibiles. Il permet de générer des
    parseurs pour des langages LR(1) et LALR(1). Il ne génère des Parseurs que
    pour Rust.
    / #link("https://cenotelie.fr/projects/hime")[Hime]: prend en charge des
    grammaires comme LR(1), GLR, et LALR(1), avec une capacité à gérer des
    grammaires ambiguës. Il peut générer des parseurs pour C\#, Java et Rust.
    / #link("https://tree-sitter.github.io/tree-sitter/")[Tree-sitter]: génère
    des parseurs incrémentaux en temps réel, utilisés dans des environnements
    interactifs comme des éditeurs de texte. Il peut générer des parseurs pour
    C\#, Go, Haskell, Java (JDK 22), JavaScript (Node.js), JavaScript (Wasm),
    Kotlin, Python, Rust, et d'autres langages de manière non supportée
    officiellement.
    / #link("https://github.com/DmitrySoshnikov/syntax")[Syntax]: génère des
    parseurs pour des grammaires LR et LL. Il peut générer des parseurs pour
    JavaScript, Python, PHP, Ruby, C++, C\#, Rust, Java, et Julia. Disponible
    sur https://github.com/DmitrySoshnikov/syntax

    #figure(
      table(
        columns: (auto, auto, auto),
        [],                       [*Grammaires supportées*],             [*Langages supportés*],
        [*Pest*],                 [PEG],                                 [Rust],
        [*LALRPOP*],              [LR(1), LALR(1)],                      [Rust],
        [*Hime*],                 [LR(1), GLR, LALR(1)],                 [C\#, Java, Rust],
        [*Tree-sitter*],          [GLR],                                 [C\#, Go, Haskell, Java, JS],
        [*Syntax*],               [LR, LL],                              [JavaScript, Python, PHP, Ruby, C++, C\#, Rust, Java, Julia],
      )
    )

  ],

  derivation: [
    #todo[exemple de dérivation]
  ],

  packages: [
    Rust a un gestionnaire de paquet officiel, `cargo` qui est également son
    moteur de production (_build system_). Il permer de télécharger, compiler,
    distribuer et de téléverser des paquets (nommés _crates_) dans un registre
    central (#link("https://crates.io")[crates.io]) des registres privés ou à
    partir de dépôts git. Une interface alternative à crates.io est disponible
    sur #link("https://lib.rs")[lib.rs]. Il sert également d'interface au
    compilateur, au linter, au formatteur, au générateur de documentation, au
    harnais de test et de benchmarking et plus grâce à son sytème de plugins.
    Ce gestionnaire de paquets est l'un des points forts de Rust, permettant
    une expérience de développement fluide, se résumant souvent à lancer `cargo
    build` après avoir obtenu les sources.
  ],

  communaute: [
    La communauté est riche et forte de nombreux développeurs à travers le
    monde. Ceux-ci se retrouvent en personne lors de conférences
    internationales ou à plus petite échelle, mais également en ligne. Cette
    communauté produit un écosystème riche de librairies. On peut estimer qu'il
    existe aujourd'hui 100#{sym.space.nobreak.narrow}000 _crates_ "sérieuses"
    sur les 128#{sym.space.nobreak.narrow}256 que compte `crates.io`.

  ],

  assurances: [
    Le langage Rust, à l'inverse du C, intègre nativement des mécanismes de
    sécurité et de fiabilité, notamment grâce à son système de gestion de la
    mémoire et son modèle d'_ownership_. Rust a été pensé dès sa conception
    pour éviter certaines classes de bugs courants en C, comme les dépassements
    de tampon ou les erreurs liées à la gestion manuelle de la mémoire. Ces
    garanties sont intrinsèques au langage, sans recours à des outils externes,
    ce qui permet d'assurer un niveau de sûreté élevé dès l'écriture du code.
    De plus, Rust privilégie la détection des erreurs à la compilation plutôt
    qu'à l'exécution, minimisant ainsi les risques d'incidents en production.
    Toutefois, cette rigueur impose une courbe d'apprentissage plus raide, et
    si Rust réduit les besoins en outils de vérification supplémentaires, il
    peut introduire une complexité accrue dans l'écriture de certains
    programmes.

  ],

  adherence: [
    Rust a les même caractéristiques que C (détaillées #ref(<c-bare-metal>),
    p.~#pageref(<c-bare-metal>)) en termes d'utilisabilité sur un système nu.
  ],


  interfacage: [
    Rust permet d'exposer le code écrit avec une interface compatible C et
    d'appeler du code C, on référera donc le lecteur à la #ref(<c-abi>),
    p.~#pageref(<c-abi>).
  ],

  critique: [
    Il n'existe à ce jour pas de communication officielle sur un logiciel
    embarqué critique qui serait en production en Rust. Néanmoins,
    officieusement, de tels projets sont en développement dans les domaines de
    l'automobile, de l'armement, et de l'aérospatiale.
  ]
)

