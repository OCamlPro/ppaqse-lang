#import "defs.typ": *
#import "links.typ": *


#language(
  name:"Rust",

  introduction: [
    #Rust est un langage de programmation créé par Graydon Hoare en 2006,
    soutenu par la fondation Mozilla à partir de 2009, et dont la première
    version stable fût publiée en 2015. Le projet est devenu indépendant de
    Mozilla et est soutenu par sa propre entité légale: la fondation #Rust.
    Conçu
    comme un successeur aux langages C et C++, #Rust cherche à concillier
    sûreté, performance et correction du code concurent. Il est souvent utilisé
    pour des applications systèmes, des logiciels embarqués, des navigateurs et
    des applications web.

    Il n'existe pas à l'heure actuelle de standard du langage, mais deux
    projets dans ce sens existent :
    1. Les entreprises AdaCore et Ferrous Systems ont développé une version
      qualifiée du compilateur standard Rust, nommée
      #link("https://ferrocene.dev/en/")[Ferrocene], certifiée ISO26262 (ASIL D)
      et IEC 61508 (SIL 4) pour les plateformes x86 et ARM. Celle-ci est mise à
      jour tous les trois mois, soit toutes les deux à trois versions de Rust.
      <ferrocene>
    2. La fondation #Rust a lancé un projet de rédaction d'une spécification.
      Ce projet semble sérieux et devrait aboutir a une
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
    Rust est un langage multi-paradigme qui permet la programmation
    #paradigme[impérative],
    #paradigme[fonctionnelle], et (de manère plus limitée) orientée
    #paradigme[objet].

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

    et l'équivalent dans un style impératif:

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
  ],


  model_intro: [

  ],

  runtime: [
    #let mirai = link("https://github.com/endorlabs/MIRAI")[Mirai]

    La jeunesse du langage fait que la plupart des outils d'analyse ou de
    vérification sont encore des projets de recherche. En terme d'analyse
    statique, il existe #mirai qui fait de l'analyse statique sur le langage
    intermédiaire du compilateur #Rust. Il peut identifier certaines classes
    d'erreurs en s'aidant éventuellement d'annotations.

  ],

  wcet: [
    Il n'existe à ce jour pas d'outil sur étagère permettant de faire de
    l'analyse WCET de programmes spécifiquement Rust. Néanmoins, les outils
    fonctionnant sur du code machine évoqués dans la partie C peuvent être
    utilisés.
  ],

  pile: [
    Il n'y a pas d'outil recensé faisant de l'analyse statique de pile sur
    un programme #Rust. Toutefois, les outils fonctionnant sur du code machine
    évoqués dans la partie C peuvent être utilisés.
  ],

  numerique: [
    Il n'y a pas d'outils recensé pour faire de l'analyse numérique statique
    #Rust.

    Il existe néanmoins plusieurs bibliothèques permettant de travailler avec
    plus de précision qu'avec des flottants 32 ou 64 bits. Certaines permettent
    - du calcul à virgule fixe (#crate("bigdecimal"), #crate("rust_decimal"));
    - des entiers de taille arbitraire(#crate("num"), #crate("ruint");
      #crate("rug"));
    - des fractions (#crate("num"), #crate("rug"));
    - des flottants de précision arbitraire (#crate("rug") ou
      #crate("gmp-mpfr-sys") basées sur #mpfr ou #gmp).

  ],

  formel: [
    La vérification formelle de code #Rust suscite un certain intérêt puisque
    malgré la jeunesse du langage, il y a déjà plusieurs initiatives sur le sujet.
    Toutefois, il s'agit de projets académiques et aucun ne bénéficie d'un
    support commercial pour le moment.

    *Creusot*

    #let creusot = link("https://github.com/creusot-rs/creusot")[Creusot]

    #creusot#footnote[https://github.com/creusot-rs/creusot] est un outil de
    vérification déductive de code #Rust. Il a son propre langage de
    specification nommé _pearlite_. Il traduit le code #Rust et sa
    specification
    _pearlite_ en code WhyML, utilisé ensuite par l'outil Why3. A ce jour, il a
    été utilisé pour vérifier formellement un SAT solver, CreuSAT.
    Voici un exemple d'utilisation de spécification #creusot:
    ```rust
    use creusot_contracts::*;

    #[requires(x < i32::MAX)]
    #[ensures(result@ == x@ + 1)]
    pub fn add_one(x: i32) -> i32 {
        x + 1
    }
    ```
    et la commande

    *Flux*

    #let flux = link("https://flux-rs.github.io/flux/")[Flux]

    #flux#footnote["https://flux-rs.github.io/flux/] augmente #Rust en lui
    rajoutant des types par rafinement. Il a également son propre langage de
    spécification qui ne porte pas de nom. Il transforme ces types en Clauses
    de Horn Contraintes (CHC) et utilise directement le solver #z3 pour les
    résoudre. Par exemple :
    ```rust
    #[flux::sig(fn(x: i32) -> i32{v: x < v})]
    pub fn inc(x: i32) -> i32 {
      x - 1
    }
    ```
    donnera une erreur lors de la compilation:
    ```
    error[FLUX]: postcondition might not hold
    --> test0.rs:3:5
      |
    3 |     x - 1
      |     ^^^^^
    ```


    *Aenas*

    #let hol = link("https://hol-theorem-prover.org/")[HOL]

    #link("https://github.com/AeneasVerif/aeneas")[Aenas] et
    #link("https://github.com/AeneasVerif/charon")[Charon] sont deux outils,
    développés dans
    le cadre du même projet. Ils permettent de traduire du code #Rust vers
    différents langages de spécification formelle afin de pouvoir écrire des
    preuves dessus. Les langages de preuve supportés sont F\*, #coq,
    #hol et
    #lean.

    *Verus*

    #link("https://github.com/verus-lang/verus")[Verus] permet également
    d'ajouter des spécifications à du code #Rust, et de vérifier qu'elles sont
    satisfaites pour toute execution possible du programme. Il s'appuie
    directement sur le solveur SMT #z3. Voici un exemple d'utilisation:
    ```rust
    fn octuple(x1: i8) -> i8
        requires
            -64 <= x1,
            x1 < 64,
    {
        let x2 = x1 + x1;
        let x4 = x2 + x2;
        x4 + x4
    }
    ```
  ],

  intrinseque: [

    *Erreurs*

    En Rust, les erreurs sont rendues explicites dans les types de retour, et
    le compilateur signale lorsque l'on a omis de vérifier une potentielle
    valeur d'erreur. Par exemple, pour cette fonction qui vérifie si un fichier
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

    Il en est de même si on oublie de vérifier qu'une fonction à effet de
    bord n'a pas retourné d'erreur:

    ```rust
    fn write(path: impl AsRef<Path>, content: &str) -> Result<(), std::io::Error> {
        std::fs::write(path, content)
    }

    fn main() {
        write("user.txt", "John Smith");
    }
    ```

    on obtient alors le warning:

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

    *Régions mémoire*

    #Rust dispose d'un mécanisme innovant de gestion de la mémoire par régions
    qui permet de garantir la sûreté mémoire au moment de la compilation
    sans avoir recours à un rammasse-miettes au _runtime_.
    Celui-ci, lié au système d'_ownership_ permet d'éviter les erreurs
    suivantes:
    - _use after free_
    - _data races_
    - _dangling pointers_
    - erreurs liés à l'_aliasing_ de pointeurs

  ],

  tests: [
    #Rust inclut un cadre de test standard qui permet de gérer les tests
    unitaires via des annotations et des macros:
    ```rust
    #[cfg(test)]
    mod tests {
        #[test]
        fn it_works() {
            assert_eq!(2 + 2, 4);
        }
    }
    ```
    Avec ces annotations, le compilateur #Rust génère un exécutable de test
    qui peut être lancé avec la commande `cargo test`.

    #let rs_quickcheck = link(
      "https://crates.io/crates/quickcheck",
      `quickcheck`
    )
    #let rs_proptest = link(
      "https://crates.io/crates/proptest",
      `proptest`
    )
    #let rs_mockall = link(
      "https://crates.io/crates/mockall/",
      `mockall`
    )

    Toutefois, les fonctionnalités fournies par ce cadre sont minimalistes et
    des paquets #Rust complètent le service en y ajoutant du _fuzzing_
    (#rs_quickcheck, #rs_proptest) ou du _mocking_ (#rs_mockall).

    Il ne semble pas exister d'outil permettant d'engendrer des rapports de
    tests standardisés ou conforme à une norme particulière. `cargo test`
    permet toutefois d'engendrer un rapport JSON qui peut être traité par
    des outils tiers.
  ],

  compilation: [
    Hormis le compilateur Ferrocene mentionné précedemment qui n'est autre
    qu'une version qualifiée du
    compilateur standard `rustc`, il n'existe aujourd'hui pas de
    compilateur alternatif utilisable.

    On peut néanmoins mentionner les projets suivants:
    - #link("https://rust-gcc.github.io/")[*gccrs*] vise à développer un
      _frontend_ #Rust pour #gcc. L'ensemble formerait un compilateur
      entièrement différent de `rustc`.
    - #link("https://github.com/rust-lang/rustc_codegen_gcc")[*rust codegen
      gcc*] qui consiste à brancher le _backend_ de #gcc au _frontend_ de
      `rustc`. Cela permettrait de
      supporter les plateformes déjà supportées par #gcc mais ne constituerait
      pas une implémentation différente de `rustc`.
    - #link("https://github.com/rust-lang/rustc_codegen_cranelift")[*rust
      codegen cranelift*] qui consiste à brancher _cranelift_ sur le
      _frontend_ de `rustc`
      afin de
      permettre des temps de compilation plus rapides en mode dit _debug_
      (c'est à dire sans les optimisations). Là encore, il s'agirait d'utiliser
      une partie de `rustc`.

  ],

  debug: [
    Le langage Rust supporte officiellement GDB, LLDB et WinDbg/CDB.
  ],

  metaprog: [
    Le système de macro de #Rust est expressement fait pour permettre la
    métaprogrammation de manière hygiénique. Par exemple, le code suivant
    permet de créer un vecteur de trois entiers:
    ```rust
    let v: Vec<i32> = vec![1, 2, 3];
    ```
    où le symbole `!` indique l'appel à une macro (ici `vec`). Cette macro
    pourrait être définie comme suit:
    ```rust
    macro_rules! vec {
        ($($x:expr),*) => {{
            let mut temp_vec = Vec::new();
            $(temp_vec.push($x);)*
            temp_vec
        }};
    }
    ```
    où, sans entrer dans les détails, on dit au compilateur que si la macro
    est appelée avec une liste d'expressions séparées par des virgules
    (`$($x:expr),*`), alors il crée un nouveau vecteur (
    `let mut temp_vec = Vec::new();`), y ajoute les éléments de la liste
    (`$(temp_vec.push($x);)*`)
    et retourne le vecteur.

    Ce système de macro est suffisamment riche pour permettre l'écriture de
    mini-DSL, des générateurs de code ou des dérivations à partir des types.
  ],

  parsers: [
    La jeunesse du langage fait qu'il n'est pas encore très utilisé pour
    l'écriture de compilateurs ou d'interpréteurs. De fait, il n'y a pas encore
    beaucoup d'outils pour l'écriture de parseurs spécifiquement pour #Rust.
    Quelques outils ciblant plusieurs langages ont simplement
    développé un _backend_ supplémentaire pour #Rust.

    #let lalrpop = link("https://github.com/lalrpop/lalrpop", "LALRPOP")
    #let hime = link("https://cenotelie.fr/projects/hime", "Hime")
    #let syntax = link("https://github.com/DmitrySoshnikov/syntax", "Syntax")

    Au niveau des _lexers_, il n'y a que #re2c supporte #Rust. #lalrpop a
    également un générateur de _lexer_ intégré. Pour les _parsers_, il y en
    a essentiellement trois: #lalrpop, #hime et #syntax. Notons que #lalrpop
    embarque le _parsing_ dans #Rust via des macros procédurales.

    #figure(
      table(
        columns: (auto, auto, auto, auto, auto),
        [*Nom*],         [*Algorithme*],        [*Grammaire*], [*Code*],  [*Plateforme*],
        [*LALRPOP*],     [LR(1), LALR(1)],      [Rust],        [Rust],    [Toutes],
        [*Hime*],        [LR(1), GLR, LALR(1)], [EBNF],        [Séparé],  [.NET, JVM],
        [*Syntax*],      [LR, LL],              [JSON, Yacc],  [Mixte],   [Toutes],
      )
    )

  ],

  derivation: [
    La métaprogrammation autorisée par les macros de #Rust permet également
    de dériver du code à partir des types. Le code suivant définit
    ce qu'on appelle une macro procédurale qui va générer du code #Rust à
    partir de code #Rust.
    ```rust
    use proc_macro::TokenStream;
    use quote::quote;

    #[proc_macro_derive(HelloMacro)]
    pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
      // Construct a representation of Rust code as a syntax tree
      // that we can manipulate
      let ast = syn::parse(input).unwrap();

      // Build the trait implementation
      let name = &ast.ident;
      let gen = quote! {
          impl HelloMacro for #name {
              fn hello_macro() {
                  println!("Hello, Macro! My name is {}!", stringify!(#name));
              }
          }
      };
      gen.into()
    }
    ```
    Dans cet exemple, on définit une bibliothèque de dérivation qui prend un
    code #Rust (`input: TokenStream`), le parse
    (`let ast = syn::parse(input).unwrap();`) en un bout d'AST puis contruit
    un nouveau code
    #Rust (`let gen = quote! { ... };`) avec les informations contenues dans
    l'AST. En définissant le trait `HelloMacro` par ailleurs:
    ```rust
    pub trait HelloMacro {
        fn hello_macro();
    }
    ```
    on peut alors utiliser la macro `hello_macro` pour dériver le code
    idoine:
    ```rust
    #[derive(HelloMacro)]
    struct Foo;


    fn main() {
        Pancakes::hello_macro();
    }
    ```
    qui affichera `Hello, Macro! My name is Foo!`.

  ],

  packages: [

    Le gestionnaire de paquet officiel de #Rust est `cargo`. C'est également
    l'outil de _build_ du langage. Il permer de télécharger, compiler,
    distribuer et de téléverser des paquets (nommés _crates_) dans des registres
    partagés ou de dépôts Git.
    Les registres peuvent être publics ou privés. Le registre public par défaut
    est #crates_io mais il y a également #lib_rs qui est également très utilisé.

    Ce gestionnaire de paquets est l'un des points forts de #Rust car il
    facile l'installation d'un environnement de développement propre et
    le _build_ d'un projet #Rust.
  ],

  communaute: [
    La communauté #Rust comprend un tissu associatif (fondation #Rust,
    #Rust France, ...) et des entreprises qui organisent régulièrement des
    événements (meetups, conférences, ...) au travers le monde.

    Le langage attire beaucoup de jeunes développeurs séduits par la fiabilité
    et les performances mis en avant par le langage. Il suffit de voir le
    nombre de paquets logiciels crées pour #Rust qui atteint plus de 130 0000
    sur #crates_io en moins de 10 ans#footnote[https://lib.rs/stats].
  ],

  assurances: [
    Le langage #Rust intègre nativement des mécanismes de
    sécurité et de fiabilité :
    - un typage statique et fort;
    - un système de gestion de la mémoire et son modèle d'_ownership_.
    Ces mécanismes, et tout une panoplie de contrôles à la compilation,
    permettent de limiter le besoin d'outils externes pour
    fiabiliser la production.

    Cette rigueur peut amener le compilateur à rejeter
    des programmes qui pourraient être valides et cela peut destabiliser les
    nouveaux programmeurs habitués au C/C++. De fait, le langage est
    reconnu pour avoir un ticket d'entrée plutôt élévé et il n'est pas clair
    aujourd'hui si cela est un avantage ou un inconvénient d'un point de vue
    industriel. D'un côté, cela permet de réduire les erreurs de programmation
    et de limiter les failles de sécurité. D'un autre côté, cela peut
    ralentir le développement et engendrer des circonvonlutions
    pour faire accepter le programme au compilateur, engendrant ainsi une dette
    technique similaire à celle du C++ utilisé par des spécialistes.

    Toutefois, le langage jouit d'un réel engouement et il est même conseillé
    par l'ANSSI dans les développements
    sécurisé au titre de la démarche de sécurité par conception.

  ],

  adherence: [
    Comme le C, #Rust peut être utilisé sur un système nu en spécifiant
    `no_std` :

    ```rust
    #![no_main]
    #![no_std]

    use core::panic::PanicInfo;

    #[panic_handler]
    fn panic(_panic: &PanicInfo) -> ! {
        loop {}
    }
    ```
  ],


  interfacage: [
    #Rust a une FFI lui permettant d'interagir avec le C soit en important
    du C :
    ```rust
    #[link(name = "my_c_library")]
    extern "C" {
        fn my_c_function(x: i32) -> bool;
    }
    ```
    soit en exportant du #Rust vers du C:
    ```rust
    #[no_mangle]
    pub extern "C" fn callable_from_c(x: i32) -> bool {
        x % 3 == 0
    }
    ```
    Par transitivité, #Rust est compatible avec tous les langages compatibles
    avec le C.
  ],

  critique: [
    Il n'existe à ce jour pas de communication officielle sur un logiciel
    embarqué critique qui serait en #Rust. Toutefois les demarches de
    Ferocene et la fondation #Rust indiquent clairement une volonté de
    pénétrer le marché du logiciel critique et certains constructeurs
    automobiles ont déjà manifesté leur intérêt pour le langage.
  ]
)

