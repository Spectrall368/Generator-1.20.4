<#include "mcitems.ftl">
/*@ItemStack*/(ItemStack.of(${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().copyTag().getCompound(${input$tagName})))