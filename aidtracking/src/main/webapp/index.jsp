<html>
<head>
    <script src="js/jquery-1.5.1.min.js"></script>  
    <script>  
        jQuery(window).ready(function(){  
            navigator.geolocation.getCurrentPosition(handle_geolocation_query);  
        });  
  
        function handle_geolocation_query(position){  
            alert('Lat: ' + position.coords.latitude + ' ' +  
                  'Lon: ' + position.coords.latitude);  
        }  
    </script>  
</head>
<body>
<h1>Top page</h1>
<h2>Date is <%= new java.util.Date().toString() %></h2>
</body>
</html>