# GV Keycloak registration theme and identifier generator

This package uses **native Keycloak theming + a custom `FormAction` provider**.

Why not Keycloakify?

- The visual part of the request is small: a registration helper panel and a bit of styling.
- The important part is **server-side registration logic**: computing an immutable username, validating uniqueness, and persisting source attributes.
- In Keycloak, this kind of registration mutation belongs in the **Authentication SPI / `FormAction`** instead of a frontend-only theme.

## What it does

At self-registration time it:

1. Reads two explicit source fields:
   - `given_name_for_id`
   - `family_name_for_id`
2. Normalizes them:
   - lowercase
   - removes accents
   - removes spaces, apostrophes, and hyphens
3. Builds a base identifier using:

```text
family[:4] + given[:4]
```

4. Appends a counter without a dash:

```text
mannchri1
mannchri2
```

5. Rejects a short blocked-substring list for obviously awkward identifiers.
6. Stores the two source fields back on the user as attributes.
7. Shows a frontend preview on the registration page so the rule is visible to the user.

## Files

- `src/main/java/.../GvIdentifierFormAction.java`
  - validation and username generation
- `src/main/java/.../GvIdentifierFormActionFactory.java`
  - provider registration
- `theme/gv-login/login/theme.properties`
  - native Keycloak login theme
- `theme/gv-login/login/resources/js/gv-register.js`
  - registration preview
- `theme/gv-login/login/resources/css/gv.css`
  - preview styling

## Keycloak admin configuration

### 1. Build the provider jar

```bash
mvn package
```

### 2. Deploy it

Copy the built jar to Keycloak's `providers/` directory, then rebuild Keycloak:

```bash
cp target/gv-keycloak-registration-theme-0.1.0.jar /opt/keycloak/providers/
/opt/keycloak/bin/kc.sh build
```

### 3. Enable the theme

In the realm:

- **Realm Settings** → **Themes** → **Login Theme** → `gv-login`

### 4. Add the registration action

- **Authentication** → **Flows**
- Copy the built-in **Registration** flow
- In **Registration Form**, add execution:
  - `GV Identifier Generator`
- Move it **after** `Registration User Creation`
- Bind the copied flow as the realm registration flow

### 5. Add the explicit profile fields

In **User Profile**, create two attributes that are shown on registration:

- `given_name_for_id`
- `family_name_for_id`

Recommended labels:

- English: `Given name for identifier`, `Family name for identifier`
- French: `Prénom pour l'identifiant`, `Nom de famille pour l'identifiant`

You can also keep standard `firstName` and `lastName`; this provider falls back to them if the explicit fields are not configured.

## Important notes

- This package assumes usernames are enabled in your realm, even if you hide them in the UI.
- The immutable technical username is **not** the public actor address. Public identities such as `alice.gv.je` or `alicesrestaurant.gv.je` should remain separate.
- The blocked-substring list is intentionally short. Extend it to match your moderation policy.
- If you want the preview text translated, replace the current message files with fully translated strings.

## Suggested next step

If you also want to enforce the same policy when admins create users from the admin console or through the Admin API, add a complementary server-side validator or provisioning layer. This package currently targets **self-registration**.
