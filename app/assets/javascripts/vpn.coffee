refresh_rate = 500
setTimeout(f = (->
    $.ajax(url: "test").done (datas) ->
        $("#tes").html(datas)
    setTimeout(f, refresh_rate)
), refresh_rate)
