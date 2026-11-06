# Report Spec

## Report identity
- Report name: [Finance] - Analyse des ventes
- Semantic model: [Finance] - Analyse des ventes.SemanticModel (local, import depuis SQL Server `.\SQLEXPRESS` / `DataWarehouse` / schéma `gold`)
- Audience: Direction financière / commerciale + analystes ventes
- Primary purpose: Suivre les indicateurs décisifs des ventes (CA, marge, volumes, clients), comprendre d'où vient la croissance, repérer produits / pays / périodes qui comptent
- Delivery target: PBIP local uniquement (pas de publication Fabric)

## Semantic model binding
- Entry mode:          Local Model
- Model name:          [Finance] - Analyse des ventes
- connectionString:    byPath `../[Finance] - Analyse des ventes.SemanticModel` (déjà en place dans `definition.pbir`)

## User decisions and constraints
- Scope: rapport de ventes complet, nombre de pages et analyses laissés à mon jugement
- Page count: 4
- Interactivity: navigation = `page_navigator` (bande d'en-tête, identique sur toutes les pages) ; slicers synchronisés Année (toutes pages) ; pas de drillthrough ni bookmarks (4 pages courtes, pas de besoin)
- Design direction: champ libre ; couleurs dominantes **orange + crème**
- Publishing: non
- Tooling: Power BI Desktop (preview/screenshot) à vérifier au build ; modeling MCP disponible ; édition TMDL directe en fallback
- Model edit permissions: **à confirmer par l'approbation de ce spec** — ajout d'une table de dates, de colonnes calculées et de mesures (le modèle n'a actuellement aucune mesure ni table de dates)
- Accessibility: contraste WCAG AA, alt text sur chaque visuel, pas de couleur seule pour porter une info
- Data caveats:
  - `fact_sales` : `sales`, `price`, `quantity` en int64 (pas de décimales)
  - `dim_products[cost]` = coût unitaire, absent de la fact → marge = CA − Σ(quantité × coût). Coûts à 0 ou vides gonfleraient la marge (à contrôler par DAX au build)
  - Dates auto (LocalDateTable) activées : à remplacer par une vraie table de dates
  - `dim_customers[gender]`, `country`, `marital_status` peuvent contenir « n/a » (couche gold) — affiché tel quel, pas masqué
  - Délais expédition/échéance probablement constants dans ce jeu de données → pas de page logistique

## Narrative
- Core story: Combien vend-on, avec quelle marge, grâce à quels produits, quels clients et à quels moments ?
- Audience promise: 1 page de synthèse lisible en 10 secondes, 3 pages d'analyse pour creuser (produits, clients, saisonnalité/détail)
- Key questions answered:
  - Le CA progresse-t-il vs N-1, et où (catégorie, pays, produit) ?
  - Quelles catégories/sous-catégories sont à la fois grosses et rentables ?
  - Quels segments clients (âge, pays, genre, statut) pèsent le plus ?
  - Quels mois / jours de semaine sont forts ? Quelles commandes composent le CA ?

## Design identity
- Tone: « Atelier chaud » — éditorial chaleureux, fond crème, accents orange brûlé, texte brun foncé
- Signature: filet orange en haut de chaque carte/KPI + titres en serif (Georgia) + chiffres tabulaires
- Brownfield delta: n/a (rapport vide, thème de base Fluent2)

## Page plan
1. **Synthèse** — « Ventes : où se crée la croissance ? »
   - Archetype: Executive Summary
   - Layout variant (A): bandeau KPI + deux panneaux d'analyse + deux classements. Variant_rationale: une série mensuelle N/N-1 et trois dimensions de ventilation (catégorie, pays, produit)
   - Purpose: état global + vs N-1
   - Visuals: 6 cartes KPI (CA, Marge brute, Commandes, Panier moyen, Clients actifs, Quantité), courbe CA mensuel vs N-1, barres CA par catégorie, barres CA par pays, top 10 produits
   - Slicers: Année, Catégorie, Pays
2. **Produits & marge** — « Produits : que vend-on, avec quelle marge ? »
   - Archetype: Analytical Canvas
   - Layout variant (A): variant_rationale: hiérarchie catégorie > sous-catégorie > produit + arbitrage volume/marge
   - Visuals: 4 cartes (CA, Marge brute, Taux de marge, Prix moyen), treemap CA par catégorie>sous-catégorie, nuage de points CA × taux de marge par sous-catégorie, tableau produits avec barres de données sur taux de marge
   - Slicers: Année, Gamme, Catégorie
3. **Clients** — « Clients : qui achète et combien ? »
   - Archetype: Analytical Canvas
   - Layout variant (A): variant_rationale: 4 axes de segmentation client (âge, pays, genre×statut) + évolution + classement
   - Visuals: 4 cartes (Clients actifs, CA par client, Commandes par client, Âge moyen), colonnes CA par tranche d'âge, barres CA par pays, barres groupées CA par statut marital × genre, courbe clients actifs mensuels, top 10 clients
   - Slicers: Année, Pays, Genre
4. **Saisonnalité & commandes** — « Commandes : quand vend-on le plus ? »
   - Archetype: Analytical Canvas
   - Layout variant (A): variant_rationale: calendrier de chaleur année × mois + profil jour de semaine + détail des lignes
   - Visuals: 4 cartes (Commandes, Quantité, Panier moyen, CA du meilleur mois), matrice année × mois en dégradé orange, colonnes CA par jour de semaine, tableau détail des commandes
   - Slicers: Année, Catégorie, Pays

## Design system summary
- Theme name + base palette: « Orange Crème » — fond page `#FDF3E1`, surface carte `#FFFBF3`, orange brûlé `#D9480F`, ambre `#F08C00`, terracotta `#8C3B0F`, pêche `#FDBA74`, taupe (N-1/neutre) `#B8A58C`, texte `#3A2410`
- Color semantics: CA = orange brûlé ; Marge = ambre ; Clients = terracotta ; N-1 / comparaison = taupe ; dégradés séquentiels = crème→orange brûlé
- Typography pairing: Georgia (titres, valeurs KPI) + Segoe UI (corps, axes, tableaux)
- Layout pattern: FHD 1920×1080, marge 32, gouttière 24, grille 12×12, densité moyenne
- Accessibility commitments: texte `#3A2410` sur `#FDF3E1` > 11:1 ; orange `#B83C0A` pour texte accentué (≈5:1) ; l'orange vif `#D9480F`/`#F08C00` réservé aux marques graphiques ; étiquettes de données sur barres pour ne pas dépendre de la couleur

## Model requirements
- Existing measures: aucune
- New table: `dim_date` (calculée, DAX `CALENDAR` min→max `fact_sales[order_date]`), marquée table de dates ; colonnes Année, Trimestre, N° mois, Mois (court), N° jour semaine, Jour semaine (triées). Relation `fact_sales[order_date]` → `dim_date[Date]`. Désactivation de la date/heure automatique et suppression des `LocalDateTable_*` devenues inutiles (pour éviter double relation sur `order_date`)
- New calculated columns: `dim_customers[Nom complet]`, `dim_customers[Âge]`, `dim_customers[Tranche d'âge]` (+ colonne de tri)
- New measures (table `_Mesures`) :
  - `Chiffre d'affaires` = SUM(fact_sales[sales]) ; `Quantité vendue` ; `Nb commandes` = DISTINCTCOUNT(order_number) ; `Panier moyen` ; `Clients actifs` = DISTINCTCOUNT(customer_key) ; `CA par client` ; `Commandes par client` ; `Prix moyen`
  - `Coût total` = SUMX(fact_sales, quantity × RELATED(dim_products[cost])) ; `Marge brute` ; `Taux de marge`
  - `CA N-1` ; `Évolution CA vs N-1 %` ; `Part du CA %` ; `CA du meilleur mois` ; `Âge moyen`
- Relationship/sort requirements: tri Mois par N° mois, Jour par N° jour, Tranche d'âge par ordre

## Canonical design contract

```yaml
Design Brief:
  generated_by: powerbi-report-cli
  contract_version: 1
  mode: greenfield
  design_identity:
    tone: "Atelier chaud — éditorial chaleureux, fond crème, accents orange brûlé, texte brun foncé"
    signature: "Filet orange en tête de chaque carte, titres serif Georgia, chiffres tabulaires"
  archetype: Executive
  navigation_model: page_navigator
  color_map:
    - measure: _Mesures[Chiffre d'affaires]
      color: "#D9480F"
      tint: "#FFE3CC"
    - measure: _Mesures[Marge brute]
      color: "#F08C00"
      tint: "#FFF0CC"
    - measure: _Mesures[Clients actifs]
      color: "#8C3B0F"
      tint: "#F6DCCB"
    - measure: _Mesures[CA N-1]
      color: "#B8A58C"
      tint: "#EFE6D8"
  pages:
    - name: "Ventes : où se crée la croissance ?"
      role: landing
      archetype: Executive
      layout_variant: A
      variant_rationale: "Série mensuelle N/N-1 plus trois dimensions de ventilation (catégorie, pays, produit) appellent un bandeau KPI et quatre panneaux."
      navigation:
        - element: page_navigator
          action: PageNavigation
          target: all
          label: "Synthèse | Produits | Clients | Commandes"
      page_background: "#FDF3E1"
      layout_summary: "En-tête (titre, navigation, 3 slicers), 6 KPI, courbe N/N-1 et barres catégorie, barres pays et top produits."
      layout_contract:
        canvas: { width: 1920, height: 1080, margin: 32, gutter: 24, snap: 8 }
        grid:
          columns: 12
          rows: 12
          regions:
            header:   [1, 1, 5, 2]
            nav:      [5, 1, 9, 2]
            filters:  [9, 1, 13, 2]
            kpis:     [1, 2, 13, 4]
            trend:    [1, 4, 8, 9]
            category: [8, 4, 13, 9]
            country:  [1, 9, 7, 13]
            products: [7, 9, 13, 13]
        placements:
          - { id: page_title, region: header, kind: textbox, text: "Ventes : où se crée la croissance ?", purpose: "Poser la question de la page avant tout graphique." }
          - { id: page_nav, region: nav, kind: pageNavigator, purpose: "Naviguer entre les 4 pages." }
          - { id: year_slicer, region: filters, kind: slicer, field_bindings: "dim_date[Année]", slicer_type: dropdown, slot: 1, of: 3 }
          - { id: category_slicer, region: filters, kind: slicer, field_bindings: "dim_products[category_name]", slicer_type: dropdown, slot: 2, of: 3 }
          - { id: country_slicer, region: filters, kind: slicer, field_bindings: "dim_customers[country]", slicer_type: dropdown, slot: 3, of: 3 }
          - { id: kpi_sales, region: kpis, kind: cardVisual, purpose: "Quel CA, et quelle évolution vs N-1 ?", field_bindings: "_Mesures[Chiffre d'affaires]", color_strategy: measure_match, insight_basis: "Évolution CA vs N-1 en libellé de référence", slot: 1, of: 6 }
          - { id: kpi_margin, region: kpis, kind: cardVisual, purpose: "Quelle marge brute et quel taux ?", field_bindings: "_Mesures[Marge brute]", color_strategy: measure_match, insight_basis: "Taux de marge en libellé de référence", slot: 2, of: 6 }
          - { id: kpi_orders, region: kpis, kind: cardVisual, purpose: "Combien de commandes ?", field_bindings: "_Mesures[Nb commandes]", color_strategy: none, insight_basis: "Commandes N-1 en libellé de référence", slot: 3, of: 6 }
          - { id: kpi_basket, region: kpis, kind: cardVisual, purpose: "Quel panier moyen ?", field_bindings: "_Mesures[Panier moyen]", color_strategy: none, insight_basis: "Écart vs panier N-1", slot: 4, of: 6 }
          - { id: kpi_customers, region: kpis, kind: cardVisual, purpose: "Combien de clients actifs ?", field_bindings: "_Mesures[Clients actifs]", color_strategy: measure_match, insight_basis: "Clients actifs N-1 en libellé de référence", slot: 5, of: 6 }
          - { id: kpi_quantity, region: kpis, kind: cardVisual, purpose: "Quel volume vendu ?", field_bindings: "_Mesures[Quantité vendue]", color_strategy: none, insight_basis: "Quantité N-1 en libellé de référence", slot: 6, of: 6 }
          - { id: sales_trend, region: trend, kind: lineChart, purpose: "Comment le CA mensuel évolue-t-il vs N-1 ?", field_bindings: { Category: "dim_date[Mois]", Y: ["_Mesures[Chiffre d'affaires]", "_Mesures[CA N-1]"] }, color_strategy: measure_match }
          - { id: sales_by_category, region: category, kind: barChart, purpose: "Quelle catégorie pèse le plus dans le CA ?", field_bindings: { Category: "dim_products[category_name]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: value_desc, color_strategy: measure_match }
          - { id: sales_by_country, region: country, kind: barChart, purpose: "Quels pays génèrent le CA ?", field_bindings: { Category: "dim_customers[country]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: value_desc, color_strategy: measure_match }
          - { id: top_products, region: products, kind: barChart, purpose: "Quels 10 produits font le plus de CA ?", field_bindings: { Category: "dim_products[product_name]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: value_desc, color_strategy: measure_match }
        space_audit:
          content_cell_count: 132
          placed_cell_count: 132
          empty_cell_pct: 0
          unplaced_regions: []
          largest_region: { name: trend, pct_of_content: 27 }
          balance_rationale: "Bandeau KPI (18%), courbe N/N-1 (27%) et trois classements de taille comparable ; aucune bande vide. Aucune carte n'est le hero : chaque KPI porte un contexte N-1."
    - name: "Produits : que vend-on, avec quelle marge ?"
      role: detail
      archetype: Analytical
      layout_variant: A
      variant_rationale: "Hiérarchie catégorie > sous-catégorie > produit et arbitrage volume/marge appellent treemap + nuage de points + tableau."
      navigation:
        - element: page_navigator
          action: PageNavigation
          target: all
          label: "Synthèse | Produits | Clients | Commandes"
      page_background: "#FDF3E1"
      layout_summary: "En-tête, 4 KPI, treemap et nuage de points côte à côte, tableau produits en bas."
      layout_contract:
        canvas: { width: 1920, height: 1080, margin: 32, gutter: 24, snap: 8 }
        grid:
          columns: 12
          rows: 12
          regions:
            header:  [1, 1, 5, 2]
            nav:     [5, 1, 9, 2]
            filters: [9, 1, 13, 2]
            kpis:    [1, 2, 13, 4]
            treemap: [1, 4, 6, 9]
            scatter: [6, 4, 13, 9]
            detail:  [1, 9, 13, 13]
        placements:
          - { id: page_title, region: header, kind: textbox, text: "Produits : que vend-on, avec quelle marge ?", purpose: "Poser la question de la page." }
          - { id: page_nav, region: nav, kind: pageNavigator, purpose: "Naviguer entre les 4 pages." }
          - { id: year_slicer, region: filters, kind: slicer, field_bindings: "dim_date[Année]", slicer_type: dropdown, slot: 1, of: 3 }
          - { id: line_slicer, region: filters, kind: slicer, field_bindings: "dim_products[product_line]", slicer_type: dropdown, slot: 2, of: 3 }
          - { id: category_slicer, region: filters, kind: slicer, field_bindings: "dim_products[category_name]", slicer_type: dropdown, slot: 3, of: 3 }
          - { id: kpi_sales, region: kpis, kind: cardVisual, purpose: "Quel CA ?", field_bindings: "_Mesures[Chiffre d'affaires]", color_strategy: measure_match, insight_basis: "Évolution vs N-1", slot: 1, of: 4 }
          - { id: kpi_margin, region: kpis, kind: cardVisual, purpose: "Quelle marge brute ?", field_bindings: "_Mesures[Marge brute]", color_strategy: measure_match, insight_basis: "Marge N-1 en libellé de référence", slot: 2, of: 4 }
          - { id: kpi_margin_rate, region: kpis, kind: cardVisual, purpose: "Quel taux de marge ?", field_bindings: "_Mesures[Taux de marge]", color_strategy: measure_match, insight_basis: "Écart en points vs N-1", slot: 3, of: 4 }
          - { id: kpi_price, region: kpis, kind: cardVisual, purpose: "Quel prix moyen ?", field_bindings: "_Mesures[Prix moyen]", color_strategy: none, insight_basis: "Écart vs prix moyen N-1", slot: 4, of: 4 }
          - { id: category_treemap, region: treemap, kind: treemap, purpose: "Comment le CA se répartit-il entre catégories et sous-catégories ?", field_bindings: { Group: ["dim_products[category_name]", "dim_products[subcategory]"], Values: "_Mesures[Chiffre d'affaires]" }, sort_policy: value_desc, color_strategy: gradient }
          - { id: margin_scatter, region: scatter, kind: scatterChart, purpose: "Quelles sous-catégories sont grosses ET rentables ?", field_bindings: { Details: "dim_products[subcategory]", X: "_Mesures[Chiffre d'affaires]", Y: "_Mesures[Taux de marge]", Size: "_Mesures[Quantité vendue]" }, color_strategy: measure_match, comparison_basis: "Taux de marge global du périmètre filtré" }
          - { id: product_table, region: detail, kind: tableEx, purpose: "Quels produits suivre en détail ?", field_bindings: ["dim_products[product_name]", "dim_products[category_name]", "dim_products[product_line]", "_Mesures[Quantité vendue]", "_Mesures[Chiffre d'affaires]", "_Mesures[Marge brute]", "_Mesures[Taux de marge]"], sort_policy: value_desc, color_strategy: gradient }
        space_audit:
          content_cell_count: 132
          placed_cell_count: 132
          empty_cell_pct: 0
          unplaced_regions: []
          largest_region: { name: detail, pct_of_content: 36 }
          balance_rationale: "Treemap (19%) et nuage de points (27%) portent l'analyse ; le tableau (36%) donne le détail produit sans écraser les graphiques ; bandeau KPI avec contexte."
    - name: "Clients : qui achète et combien ?"
      role: detail
      archetype: Analytical
      layout_variant: A
      variant_rationale: "Quatre axes de segmentation client (âge, pays, statut×genre), une évolution et un classement."
      navigation:
        - element: page_navigator
          action: PageNavigation
          target: all
          label: "Synthèse | Produits | Clients | Commandes"
      page_background: "#FDF3E1"
      layout_summary: "En-tête, 4 KPI, trois graphiques de segmentation, courbe clients actifs et top 10 clients."
      layout_contract:
        canvas: { width: 1920, height: 1080, margin: 32, gutter: 24, snap: 8 }
        grid:
          columns: 12
          rows: 12
          regions:
            header:      [1, 1, 5, 2]
            nav:         [5, 1, 9, 2]
            filters:     [9, 1, 13, 2]
            kpis:        [1, 2, 13, 4]
            age:         [1, 4, 5, 9]
            country:     [5, 4, 9, 9]
            marital:     [9, 4, 13, 9]
            trend:       [1, 9, 7, 13]
            top_clients: [7, 9, 13, 13]
        placements:
          - { id: page_title, region: header, kind: textbox, text: "Clients : qui achète et combien ?", purpose: "Poser la question de la page." }
          - { id: page_nav, region: nav, kind: pageNavigator, purpose: "Naviguer entre les 4 pages." }
          - { id: year_slicer, region: filters, kind: slicer, field_bindings: "dim_date[Année]", slicer_type: dropdown, slot: 1, of: 3 }
          - { id: country_slicer, region: filters, kind: slicer, field_bindings: "dim_customers[country]", slicer_type: dropdown, slot: 2, of: 3 }
          - { id: gender_slicer, region: filters, kind: slicer, field_bindings: "dim_customers[gender]", slicer_type: dropdown, slot: 3, of: 3 }
          - { id: kpi_customers, region: kpis, kind: cardVisual, purpose: "Combien de clients actifs ?", field_bindings: "_Mesures[Clients actifs]", color_strategy: measure_match, insight_basis: "Évolution vs N-1", slot: 1, of: 4 }
          - { id: kpi_sales_per_customer, region: kpis, kind: cardVisual, purpose: "Quel CA par client ?", field_bindings: "_Mesures[CA par client]", color_strategy: measure_match, insight_basis: "Écart vs N-1", slot: 2, of: 4 }
          - { id: kpi_orders_per_customer, region: kpis, kind: cardVisual, purpose: "Quelle fréquence d'achat ?", field_bindings: "_Mesures[Commandes par client]", color_strategy: none, insight_basis: "Écart vs N-1", slot: 3, of: 4 }
          - { id: kpi_age, region: kpis, kind: cardVisual, purpose: "Quel âge moyen ?", field_bindings: "_Mesures[Âge moyen]", color_strategy: none, insight_basis: "Âge moyen tous clients en libellé de référence", slot: 4, of: 4 }
          - { id: sales_by_age, region: age, kind: columnChart, purpose: "Quelles tranches d'âge pèsent le plus dans le CA ?", field_bindings: { Category: "dim_customers[Tranche d'âge]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: natural_order, color_strategy: measure_match }
          - { id: sales_by_country, region: country, kind: barChart, purpose: "Quels pays achètent le plus ?", field_bindings: { Category: "dim_customers[country]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: value_desc, color_strategy: measure_match }
          - { id: sales_by_marital, region: marital, kind: clusteredBarChart, purpose: "Comment le CA se répartit-il par statut marital et genre ?", field_bindings: { Category: "dim_customers[marital_status]", Series: "dim_customers[gender]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: value_desc, color_strategy: unique }
          - { id: active_customers_trend, region: trend, kind: lineChart, purpose: "Le nombre de clients actifs progresse-t-il ?", field_bindings: { Category: "dim_date[Mois]", Y: "_Mesures[Clients actifs]" }, color_strategy: measure_match }
          - { id: top_customers, region: top_clients, kind: tableEx, purpose: "Quels 10 clients rapportent le plus ?", field_bindings: ["dim_customers[Nom complet]", "dim_customers[country]", "_Mesures[Nb commandes]", "_Mesures[Chiffre d'affaires]"], sort_policy: value_desc, color_strategy: gradient }
        space_audit:
          content_cell_count: 132
          placed_cell_count: 132
          empty_cell_pct: 0
          unplaced_regions: []
          largest_region: { name: trend, pct_of_content: 18 }
          balance_rationale: "Cinq panneaux de taille voisine (15 à 18%) pour une exploration par segment ; aucun ne domine, aucune zone vide."
    - name: "Commandes : quand vend-on le plus ?"
      role: detail
      archetype: Analytical
      layout_variant: A
      variant_rationale: "Saisonnalité annuelle (année × mois) et hebdomadaire (jour) plus le détail des lignes de commande."
      navigation:
        - element: page_navigator
          action: PageNavigation
          target: all
          label: "Synthèse | Produits | Clients | Commandes"
      page_background: "#FDF3E1"
      layout_summary: "En-tête, 4 KPI, matrice de chaleur année × mois, colonnes par jour de semaine, tableau de détail."
      layout_contract:
        canvas: { width: 1920, height: 1080, margin: 32, gutter: 24, snap: 8 }
        grid:
          columns: 12
          rows: 12
          regions:
            header:  [1, 1, 5, 2]
            nav:     [5, 1, 9, 2]
            filters: [9, 1, 13, 2]
            kpis:    [1, 2, 13, 4]
            heatmap: [1, 4, 8, 9]
            weekday: [8, 4, 13, 9]
            orders:  [1, 9, 13, 13]
        placements:
          - { id: page_title, region: header, kind: textbox, text: "Commandes : quand vend-on le plus ?", purpose: "Poser la question de la page." }
          - { id: page_nav, region: nav, kind: pageNavigator, purpose: "Naviguer entre les 4 pages." }
          - { id: year_slicer, region: filters, kind: slicer, field_bindings: "dim_date[Année]", slicer_type: dropdown, slot: 1, of: 3 }
          - { id: category_slicer, region: filters, kind: slicer, field_bindings: "dim_products[category_name]", slicer_type: dropdown, slot: 2, of: 3 }
          - { id: country_slicer, region: filters, kind: slicer, field_bindings: "dim_customers[country]", slicer_type: dropdown, slot: 3, of: 3 }
          - { id: kpi_orders, region: kpis, kind: cardVisual, purpose: "Combien de commandes ?", field_bindings: "_Mesures[Nb commandes]", color_strategy: none, insight_basis: "Évolution vs N-1", slot: 1, of: 4 }
          - { id: kpi_quantity, region: kpis, kind: cardVisual, purpose: "Quel volume vendu ?", field_bindings: "_Mesures[Quantité vendue]", color_strategy: none, insight_basis: "Évolution vs N-1", slot: 2, of: 4 }
          - { id: kpi_basket, region: kpis, kind: cardVisual, purpose: "Quel panier moyen ?", field_bindings: "_Mesures[Panier moyen]", color_strategy: none, insight_basis: "Écart vs N-1", slot: 3, of: 4 }
          - { id: kpi_best_month, region: kpis, kind: cardVisual, purpose: "Quel est le CA du meilleur mois ?", field_bindings: "_Mesures[CA du meilleur mois]", color_strategy: measure_match, insight_basis: "Part du meilleur mois dans le CA de la période", slot: 4, of: 4 }
          - { id: season_heatmap, region: heatmap, kind: pivotTable, purpose: "Quels mois de quelles années sont les plus forts ?", field_bindings: { Rows: "dim_date[Année]", Columns: "dim_date[Mois]", Values: "_Mesures[Chiffre d'affaires]" }, sort_policy: natural_order, color_strategy: gradient }
          - { id: sales_by_weekday, region: weekday, kind: columnChart, purpose: "Quel jour de la semaine vend-on le plus ?", field_bindings: { Category: "dim_date[Jour semaine]", Y: "_Mesures[Chiffre d'affaires]" }, sort_policy: natural_order, color_strategy: measure_match }
          - { id: orders_table, region: orders, kind: tableEx, purpose: "Quelles lignes de commande composent le CA ?", field_bindings: ["fact_sales[order_number]", "fact_sales[order_date]", "dim_customers[Nom complet]", "dim_products[product_name]", "fact_sales[quantity]", "fact_sales[price]", "fact_sales[sales]"], sort_policy: none, color_strategy: none }
        space_audit:
          content_cell_count: 132
          placed_cell_count: 132
          empty_cell_pct: 0
          unplaced_regions: []
          largest_region: { name: orders, pct_of_content: 36 }
          balance_rationale: "La matrice (27%) et le profil hebdomadaire (19%) répondent à la question de la page ; le tableau (36%) sert de détail traçable ; bandeau KPI avec contexte."
  interaction_pattern:
    drill_targets: []
    cross_filter_rules: "Filter entre visuels d'une même page ; slicer Année synchronisé sur les 4 pages ; slicers Catégorie / Pays synchronisés Synthèse ↔ Commandes."
  accessibility:
    alt_text_strategy: "chart+structure : type de graphique, axes, mesure, message principal"
    contrast_notes: "Texte #3A2410 sur crème > 11:1 ; orange vif réservé aux marques graphiques, texte accentué en #B83C0A (≈5:1) ; étiquettes de données pour ne pas dépendre de la couleur seule."
  theme:
    base: "references/design/assets/base.json adapté (thème « Orange Crème », enregistré dans report.json, préservant les garde-fous textbox/card/table/en-têtes masqués)"
    user_overrides: "Couleurs dominantes orange + crème imposées par l'utilisateur"
```

## Implementation notes

- Model changes: table `dim_date`, relation, désactivation auto date/heure + suppression des `LocalDateTable_*`, colonnes calculées client, table `_Mesures` avec ~20 mesures ; validation DAX (totaux, coûts nuls, N-1)
- PBIR/report authoring: thème « Orange Crème », 4 pages 1920×1080, remplacement de « Page 1 » vide
- Validation: `powerbi-report-author` validate après chaque lot ; JSON valides
- Desktop screenshot verification: preview Desktop + screenshot des 4 pages, boucle de correction
- Publishing boundary: aucune publication
- Risks: coûts produit à 0 ; valeurs « n/a » côté clients ; suppression des tables de dates auto touche des fichiers TMDL existants (git permet le retour arrière) ; visuels cartes avec libellé de référence selon version Desktop
