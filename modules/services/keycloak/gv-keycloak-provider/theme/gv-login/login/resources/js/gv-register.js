(function() {
    function normalize(value) {
        return (value || "")
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .toLowerCase()
            .replace(/['\-\s]/g, "")
            .replace(/[^a-z0-9]/g, "");
    }

    function pickField(possibleNames) {
        for (const name of possibleNames) {
            const el = document.querySelector('[name="' + name + '"]');
            if (el) return el;
        }
        return null;
    }

    function labelOf(input) {
        if (!input) return "";
        const byFor = document.querySelector('label[for="' + input.id + '"]');
        return byFor ? byFor.textContent.trim() : input.name;
    }

    function bootstrapPreview() {
        const form = document.querySelector("form");
        if (!form) return;

        const familyInput = pickField([
            "user.attributes.family_name_for_id",
            "family_name_for_id",
            "lastName"
        ]);
        const givenInput = pickField([
            "user.attributes.given_name_for_id",
            "given_name_for_id",
            "firstName"
        ]);
        const usernameInput = pickField([
            "user.attributes.username",
            "username",
            "uid"
        ]);
        usernameInput.readOnly = false; /* The end user should increment his or herself */

        if (!familyInput || !givenInput) return;

        const container = document.createElement("div");
        container.className = "gv-identifier-preview";
        container.innerHTML = [
            '<div class="gv-identifier-preview__label">GV account identifier</div>',
            '<div class="gv-identifier-preview__value" id="gv-identifier-preview-value">—</div>',
            '<p class="gv-identifier-preview__help">',
            'Generated from ',
            '<strong>' + labelOf(familyInput) + '</strong>',
            ' + <strong>' + labelOf(givenInput) + '</strong>',
            ' using the rule <code>family[:4] + given[:4] + counter</code>. ',
            'The final number is assigned server-side to keep the identifier unique.',
            '</p>'
        ].join("");

        const anchor = usernameInput.closest(".pf-v5-c-form__group, .pf-c-form__group") || givenInput.parentElement;
        anchor.parentElement.insertBefore(container, anchor.nextSibling);

        const previewValue = container.querySelector("#gv-identifier-preview-value");
        const update = function() {
            const family = normalize(familyInput.value).slice(0, 4);
            const given = normalize(givenInput.value).slice(0, 4);

            // const suggestedUsername = family || given ? family + given + "2@" + window.location.hostname.split('.').slice(-2).join('.') : "—";
            const suggestedUsername = family || given ? family + given + "2@gv.je" : "@gv.je";
            previewValue.textContent = suggestedUsername;
            usernameInput.value = suggestedUsername;
        };

        familyInput.addEventListener("input", update);
        givenInput.addEventListener("input", update);
        update();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", bootstrapPreview);
    } else {
        bootstrapPreview();
    }
})();