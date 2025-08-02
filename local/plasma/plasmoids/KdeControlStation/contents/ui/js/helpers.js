function listProperty(item) {
    for (var p in item)
    {
        if( typeof item[p] != "function" )
            if(p != "objectName")
                console.log(p + ":" + item[p]);
    }

}