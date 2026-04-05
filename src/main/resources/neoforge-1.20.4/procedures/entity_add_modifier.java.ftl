<#assign attr = generator.map(field$attribute, "attributes")>
if (${input$entity} instanceof LivingEntity _entity) {
	AttributeModifier modifier = new AttributeModifier(UUID.fromString("${w.getUUID(field$name)}"), "${modid + ':' + field$name}", ${input$value}, AttributeModifier.Operation.${field$operation});
	if (!_entity.getAttribute(${attr}).hasModifier(modifier)) {
		<#if field$permanent == "TRUE">
			_entity.getAttribute(${attr}).addPermanentModifier(modifier);
		<#else>
			_entity.getAttribute(${attr}).addTransientModifier(modifier);
		</#if>
	}
}