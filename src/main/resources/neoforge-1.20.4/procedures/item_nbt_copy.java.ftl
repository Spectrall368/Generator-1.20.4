<#include "mcitems.ftl">
<#if field$ignoredefaults?lower_case?boolean>
AttachmentUtils.copyStackAttachments(${mappedMCItemToItemStackCode(input$a, 1)}, ${mappedMCItemToItemStackCode(input$b, 1)});
<#else>
{
    CompoundTag _nbtTag = ${mappedMCItemToItemStackCode(input$a, 1)}.getTag();
    if (_nbtTag != null)
        ${mappedMCItemToItemStackCode(input$b, 1)}.setTag(_nbtTag.copy());
}
</#if>