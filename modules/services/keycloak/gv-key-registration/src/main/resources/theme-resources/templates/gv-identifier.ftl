<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName') displayInfo=false; section>
    <#if section = "header">
        ${msg("gvCreateAccountTitle")}
    <#elseif section = "form">
        <form id="kc-gv-identifier-form" action="${url.loginAction}" method="post">
            <#if gvIdentifierRule??>
                <div class="info-message">
                    ${msg("gvIdentifierRule", gvIdentifierRule)}
                </div>
            </#if>
            
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="firstName" class="${properties.kcLabelClass!}">
                        ${msg("firstName")}
                    </label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="firstName" name="firstName"
                           class="${properties.kcInputClass!}"
                           value="${(firstName!'')}"
                           autofocus
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
                        ${msg("lastName")}
                    </label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="lastName" name="lastName"
                           class="${properties.kcInputClass!}"
                           value="${(lastName!'')}"
                           aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"/>
                    <#if messagesPerField.existsError('lastName')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input type="submit" 
                           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" 
                           value="${msg("doContinue")}"/>
                </div>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>