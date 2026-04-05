<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName') displayInfo=false; section>
    <#if section = "header">
        ${msg("gvCreateAccountTitle")}
    <#elseif section = "form">
        <form id="kc-je-gv-key-username-form" action="${url.loginAction}" method="post">
            <#if message?has_content && message.type != 'success'>
                <div class="${properties.kcAlertClass!} ${properties.kcAlertErrorClass!}">
                    <span class="${properties.kcAlertIconClass!}">
                        <i class="${properties.kcAlertIconErrorClass!}"></i>
                    </span>
                    <span class="${properties.kcAlertMessageClass!}">${message.summary?no_esc}</span>
                </div>
            </#if>

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
                           aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"/>
                    <#if messagesPerField.existsError('firstName')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

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
                           aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"/>
                    <#if messagesPerField.existsError('lastName')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <#if generatedUsername?? && generatedUsername != "">
                <div class="alert alert-success" style="background-color: #d4edda; border-color: #c3e6cb; color: #155724; padding: 12px; border-radius: 4px; margin-bottom: 20px;">
                    <strong>${msg("generatedUsernameLabel")}:</strong><br/>
                    <span style="font-size: 18px; font-weight: bold;">${generatedUsername}</span>
                    <p style="margin: 8px 0 0 0; font-size: 12px;">${msg("usernameWillBeUsed")}</p>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input type="submit" 
                           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" 
                           value="${msg("doContinue")}"/>
                </div>
            </div>
        </form>
        
        <script type="text/javascript">
            // Live preview of generated username
            (function() {
                const firstNameInput = document.getElementById('firstName');
                const lastNameInput = document.getElementById('lastName');
                
                if (firstNameInput && lastNameInput) {
                    function normalizeAndSlice(str, maxLen) {
                        if (!str) return '';
                        return str.toLowerCase()
                            .normalize('NFD')
                            .replace(/[\u0300-\u036f]/g, '')
                            .replace(/[^a-z0-9]/g, '')
                            .substring(0, maxLen);
                    }
                    
                    function updatePreview() {
                        const firstName = firstNameInput.value.trim();
                        const lastName = lastNameInput.value.trim();
                        
                        if (firstName && lastName) {
                            const base = normalizeAndSlice(lastName, 4) + normalizeAndSlice(firstName, 4);
                            let previewDiv = document.getElementById('username-preview');
                            
                            if (!previewDiv) {
                                const form = document.getElementById('kc-je-gv-key-username-form');
                                const buttonDiv = document.getElementById('kc-form-buttons');
                                previewDiv = document.createElement('div');
                                previewDiv.id = 'username-preview';
                                previewDiv.style.cssText = 'background-color: #fff3cd; border: 1px solid #ffeeba; color: #856404; padding: 12px; border-radius: 4px; margin: 20px 0;';
                                form.insertBefore(previewDiv, buttonDiv);
                            }
                            
                            previewDiv.innerHTML = '<strong>Preview:</strong> ' + base + '2...';
                            previewDiv.style.display = 'block';
                        } else {
                            const previewDiv = document.getElementById('username-preview');
                            if (previewDiv) previewDiv.style.display = 'none';
                        }
                    }
                    
                    firstNameInput.addEventListener('input', updatePreview);
                    lastNameInput.addEventListener('input', updatePreview);
                }
            })();
        </script>
    </#if>
</@layout.registrationLayout>