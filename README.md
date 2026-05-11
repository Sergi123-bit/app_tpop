Foto del logo.

<img width="225" height="225" alt="logo_del_Lobo" src="https://github.com/user-attachments/assets/938b82e1-ad71-4aa0-83a0-16a404629c3f" />

#  T-POP

Aplicació mòbil d'armari virtual intel·ligent desenvolupada amb Flutter com a projecte DAM. Permet gestionar la roba digitalment, crear conjunts i organitzar els teus looks, amb tema clar i fosc i dades sincronitzades amb Firebase Firestore.

---

## 🚀 Instal·lació

```bash
git clone https://github.com/el-teu-usuari/t-pop.git
cd t-pop
flutter pub get
flutter run
```

Dependències principals: `firebase_core`, `cloud_firestore`, `firebase_auth`, `provider`, `google_fonts`, `image_picker`, `uuid`

---

## 👤 Integrants

**Sergi Terrones Gallardo** — CFGS Desenvolupament d'Aplicacions Multiplataforma (DAM)

---

## ✅ Requisits complerts

🔐 **Login i Registre**
Autenticació amb Firebase Auth (email i contrasenya). En registrar-se, s'inicialitzen automàticament 49 prendas genèriques a Firestore.

🏠 **Dashboard**
Vista personalitzada amb el nom de l'usuari, estadístiques (prendas, favorits, talla), calendari setmanal, look del dia i prendas afegides recentment. Dades en temps real amb StreamBuilder.

👕 **Armari digital**
Grid de prendas amb filtre per categories (Totes, Superior, Inferior, Calçat…) i cerca per nom. Mostra el total de prendas i actualitza en temps real des de Firestore.

➕ **Nova prenda**
Formulari complet per afegir roba: foto, nom, tipus, categoria (detectada automàticament), color, marca, talla i descripció. Dades guardades a Firestore.

🔍 **Cerca global**
Pantalla de búsqueda que permet trobar qualsevol prenda per nom, categoria, color o marca amb resultats en temps real.

👔 **Detall de prenda**
Fitxa completa amb imatge, etiquetes (categoria, color, talla, tipus), estat de la prenda (Funciona / Desgastada / No funciona), descripció d'ús i botó de favorit.

🧩 **Conjunts**
Creació i gestió de looks (CRUD complet). Cada conjunt mostra les prendas que el formen i la seva etiqueta d'estil. Dades sincronitzades amb Firestore.

👤 **Perfil**
Vista amb estadístiques de l'usuari, llista de favorits, toggle de tema clar/fosc, edició de perfil (nom, username, talla) i preferències d'estil.

🎨 **Preferències d'estil**
Qüestionari inicial per personalitzar l'experiència: estil favorit, colors preferits, ocasió d'ús i temperatura habitual.

🌙 **Tema clar / fosc**
Canvi dinàmic de tema amb persistència. Tots els colors s'adapten automàticament via helpers de context.

---

## 📸 Captures de pantalla

### 🌞 Tema Clar

| Dashboard | Armari |
|:---------:|:------:|
| ![Dashboard Light](docs/screenshots/screen_dashboard_light.png) | ![Ropa Light](docs/screenshots/screen_ropa_light.png) |

### 🌙 Tema Fosc

| Dashboard | Armari | Conjunts |
|:---------:|:------:|:--------:|
| ![Dashboard Dark](docs/screenshots/screen_dashboard_dark.png) | ![Ropa Dark](docs/screenshots/screen_ropa_dark.png) | ![Conjuntos](docs/screenshots/screen_conjuntos_dark.png) |

| Cerca | Detall | Perfil |
|:-----:|:------:|:------:|
| ![Cerca](docs/screenshots/screen_busqueda_dark.png) | ![Detall](docs/screenshots/screen_detalle_dark.png) | ![Perfil](docs/screenshots/screen_perfil_dark.png) |

| Nova Prenda | Preferències |
|:-----------:|:------------:|
| ![Nova Prenda](docs/screenshots/screen_nueva_prenda_dark.png) | ![Preferencies](docs/screenshots/screen_preferencias_dark.png) |

---

## 🛠️ Tecnologies

- **Flutter / Dart** → Framework i llenguatge principal
- **Firebase Auth** → Autenticació email/password
- **Cloud Firestore** → Base de dades en temps real
- **Firebase Storage** → Emmagatzematge de fotos (pendent d'integrar)
- **Provider** → Gestió d'estat global (AppState)

---

## 📦 APK

L'APK funcional es troba a la carpeta `/apk` del repositori o a la secció **Releases** de GitHub.
