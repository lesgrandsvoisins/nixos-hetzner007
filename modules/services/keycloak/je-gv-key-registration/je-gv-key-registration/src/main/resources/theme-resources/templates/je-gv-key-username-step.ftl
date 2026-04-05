<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName') displayInfo=false; section>
    <#if section = "header">
        ${msg("gvCreateAccountTitle")}
    <#elseif section = "form">
        <form id="kc-je-gv-key-username-form" action="${url.loginAction}" method="post">
            <div class="info-message" style="background-color: #e8f0fe; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                <p style="margin: 0; font-size: 14px;">
                    <strong>ℹ️ ${msg("jeGvKeyUsernameRule")}</strong><br/>
                    ${msg("jeGvKeyUsernameRuleDescription", (jeGvKeyUsernameRule!'family[:4] + given[:4] + counter'))}
                </p>
            </div>

            <#-- First Name Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="firstName" class="${properties.kcLabelClass!}">
                        ${msg("firstName")} *
                    </label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" 
                           id="firstName" 
                           name="firstName"
                           class="${properties.kcInputClass!}"
                           value="${(firstName!'')}"
                           autofocus
                           required
                           aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                           placeholder="${msg("firstNamePlaceholder")}"/>
                    <#if messagesPerField.existsError('firstName')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <#-- Last Name Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="lastName" class="${properties.kcLabelClass!}">
                        ${msg("lastName")} *
                    </label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" 
                           id="lastName" 
                           name="lastName"
                           class="${properties.kcInputClass!}"
                           value="${(lastName!'')}"
                           required
                           aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                           placeholder="${msg("lastNamePlaceholder")}"/>
                    <#if messagesPerField.existsError('lastName')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <#-- Generated Username Preview (shown after generation) -->
            <#if generatedUsername?? && generatedUsername != "">
                <div class="generated-username-preview" style="background-color: #e8f5e9; padding: 12px; border-radius: 6px; margin: 20px 0; border-left: 4px solid #4caf50;">
                    <p style="margin: 0; font-size: 14px;">
                        <strong>✅ ${msg("generatedUsernameLabel")}</strong><br/>
                        <span style="font-size: 18px; font-weight: bold; color: #2e7d32;">${generatedUsername}</span>
                    </p>
                    <p style="margin: 8px 0 0 0; font-size: 12px; color: #666;">
                        ${msg("usernameWillBeUsed")}
                    </p>
                </div>
            </#if>

            <#-- Submit Button -->
            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input type="submit" 
                           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" 
                           value="${msg("doContinue")}"/>
                </div>
            </div>
        </form>

        <#-- JavaScript for live preview (optional) -->
        <script type="text/javascript">
            (function() {
                const firstNameInput = document.getElementById('firstName');
                const lastNameInput = document.getElementById('lastName');
                
                function slugify(text) {
                    return text.toLowerCase()
                        .normalize('NFD')
                        .replace(/[\u0300-\u036f]/g, '')
                        .replace(/[^a-z0-9]/g, '')
                        .substring(0, 4);
                }
                
                function updatePreview() {
                    const firstName = firstNameInput ? firstNameInput.value.trim() : '';
                    const lastName = lastNameInput ? lastNameInput.value.trim() : '';
                    
                    if (firstName && lastName) {
                        const base = slugify(lastName) + slugify(firstName);
                        const preview = base + '2'; // Simple preview
                        
                        let previewDiv = document.querySelector('.generated-username-preview');
                        if (!previewDiv) {
                            const form = document.getElementById('kc-je-gv-key-username-form');
                            const buttonDiv = document.getElementById('kc-form-buttons');
                            previewDiv = document.createElement('div');
                            previewDiv.className = 'generated-username-preview';
                            previewDiv.style.cssText = 'background-color: #fff3e0; padding: 12px; border-radius: 6px; margin: 20px 0; border-left: 4px solid #ff9800;';
                            form.insertBefore(previewDiv, buttonDiv.parentElement);
                        }
                        
                        previewDiv.innerHTML = `
                            <p style="margin: 0; font-size: 14px;">
                                <strong>🔮 ${msg("previewUsernameLabel")}</strong><br/>
                                <span style="font-size: 16px; font-family: monospace;">${preview}...</span>
                            </p>
                            <p style="margin: 8px 0 0 0; font-size: 12px; color: #666;">
                                ${msg("clickContinueToGenerate")}
                            </p>
                        `;
                    }
                }
                
                if (firstNameInput && lastNameInput) {
                    firstNameInput.addEventListener('input', updatePreview);
                    lastNameInput.addEventListener('input', updatePreview);
                }
            })();
        </script>
    </#if>
</@layout.registrationLayout>