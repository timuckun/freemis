function showSuggestions(element_id, update_id)
{
    var element = $(element_id);// .firstChild.nextSibling;
    var update = $(update_id);
    if(!update.style.position || update.style.position=='absolute')
    {
//         var offsets = Position.cumulativeOffset(element);
        update.style.left = element.offsetLeft + 'px';
        update.style.top  = (element.offsetTop + element.offsetHeight) + 'px';
        update.style.position = 'absolute';
    }
    new Element.toggle(update);
}

function isInVisible(element_id)
{
    var element = $(element_id);
    if(element.style.display && element.style.display == 'none')
        return true;
    new Element.hide(element);
    return false;
}
