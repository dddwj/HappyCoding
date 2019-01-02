<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="jquery/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/popper.min.js"></script>
    <link href="css/mycss.css" rel="stylesheet">

    <meta charset="UTF-8">
    <title>EcustMap</title>
<!--    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">-->
<!--    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>-->
<!--    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>-->
</head>


<body>
<nav class="site-header sticky-top py-1">
    <div class="container d-flex flex-column flex-md-row justify-content-between">
        <a class="py-2" href="index.html">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="d-block mx-auto"><circle cx="12" cy="12" r="10"></circle><line x1="14.31" y1="8" x2="20.05" y2="17.94"></line><line x1="9.69" y1="8" x2="21.17" y2="8"></line><line x1="7.38" y1="12" x2="13.12" y2="2.06"></line><line x1="9.69" y1="16" x2="3.95" y2="6.06"></line><line x1="14.31" y1="16" x2="2.83" y2="16"></line><line x1="16.62" y1="12" x2="10.88" y2="21.94"></line></svg>
        </a>
        <a class="py-2 d-none d-md-inline-block" href="index.html">计算路线</a>
        <a class="py-2 d-none d-md-inline-block" href="#">徐汇校区</a>
        <a class="py-2 d-none d-md-inline-block" href="http://www.ecust.edu.cn">奉贤校区</a>
        <a class="py-2 d-none d-md-inline-block" href="http://144.168.62.45">关于我</a>

    </div>
</nav>



    <div class="alert alert-secondary align-content-center text-center">
        <div class="h1">ECUST Navigator</div>
    </div>

    <div class="justify-content-center text-center">
        <?php
        //[post] URL中不带参数

        ini_set('dispaly_erors', 1);

//        error_reporting(E_ALL|E_STRICT);
        error_reporting(0);     //屏蔽报错信息。

//        if( !$_POST )
//        {
//            echo "error!";
//        }

        $points = $_POST['checkbox'];
        //var_dump($points);
        //echo count($points);

        $selectedCount = 0;
        $mapTagged = [0,29,4,30,5,38,37,21,21,16,17,39,22,31,25,28];


        for ($index = 0 ; $index < 16 ; $index++){
            if (isset($points[$index])){
                $selectedPoint[$selectedCount] = $mapTagged[$index];
                $selectedCount ++ ;
            }
            else{
                continue;
            }
        }

        if($selectedCount != 2 ){
            echo "<h3> 请选择两个点！</h3>";
            header("refresh:5; url = index.html");
            print('5秒后自动跳转。</h3>');
        }
        else {

            $myfile = fopen("/Users/dddwj/NetBeansProjects/EcustMap/src/ecustmap/input.txt", "w");
            fwrite($myfile, $selectedPoint[0] . "\n" . $selectedPoint[1]);
            exec("java -jar /Users/dddwj/NetBeansProjects/EcustMap/dist/EcustMap.jar");
            fclose($myfile);

            $resultfile = fopen("/Users/dddwj/NetBeansProjects/EcustMap/src/ecustmap/output.txt","r");
            $str = file_get_contents("/Users/dddwj/NetBeansProjects/EcustMap/src/ecustmap/output.txt");
            $arr = explode("\n",$str);
            $i = 0;
            $path = [];
            foreach( $arr as $row ){
                $row = trim($row);
                if( strlen($row) == 0)
                    break;
                $path[$i] = $row;
                $i++;
            }
            $distance = round($arr[$i+1]  * (880 / 17.6),2);

            echo "<h3>路径长度：$distance 米</h3>";  //地图比例尺 17.4cm : 880m
        }
        ?>
    </div>


    <br>

    <div class="container-fluid" style="background-image: url('img/map.JPG'); width: 1100px; height: 670px;" >
        <canvas id="canvas" width="1100" height="670">
            你的浏览器还不支持canvas
        </canvas>
    </div>

<script type="text/javascript">
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    ctx.beginPath();//这里可以理解为另外起笔，如果忽略这个步骤那么下面的样式就会继承上面的，所以最好不要忽略
    // ctx.fillStyle = "#ffff79";//定义填充样式
    ctx.lineWidth = '5';//定义线性的线宽，宽是从圆圈向内外两边同时加粗的
    ctx.strokeStyle = "#f5f044";
    ctx.shadowColor = "white";
    ctx.shadowBlur = 15;
    ctx.shadowOffsetX = 3;
    ctx.shadowOffsetY = 3;

    // ctx.lineWidth = 3;
    //
    // var point1 = { left: 172, top: 276 };//第一个点
    // var point2 = { left: 254, top: 236 };//第二个点
    // ctx.beginPath();
    // ctx.moveTo(point1.left, point1.top);//起始位置
    // ctx.lineTo(point2.left, point2.top);//停止位置
    <?php
    $descr=[];$descr_count=0;
    $db = new MySQLi("101.132.154.2","atmsys","atmsys","atmsys");
    foreach($path as $point){
        if($path=="")
            break;
        $sql2 = "select x,y from points where Vid = '{$point}';";
        $result2 = $db->query($sql2);
        if($result2){
            while($attr = $result2->fetch_row()) {
                $x = $attr[0] * 28.35;           // 本图片分辨率为 28.35像素/厘米
                $y = 670 - $attr[1] * 28.35;
//                echo "<h1>$x,$y</h1>";
                echo " ctx.arc($x,$y,3,0,2*Math.PI);//定义圆[这五个参数分别是（横坐标，纵坐标，半径，起始的点(弧度)，结束的点(弧度)）]
                       ctx.stroke();";
            }
            $isLandscape = array_search($point,$mapTagged);
            if($isLandscape){
                $descr[$descr_count++] = $point;
            }
        }
    }
    ?>

</script>

    <br>
    <div class="row justify-content-center text-center">
        <h3>你将经过以下景点...</h3>
    </div>

<div class="container align-content-center justify-content-center text-center">
    <table class="table table-hover table-striped">
        <thead class="thead-light">
        <tr>
            <th>景点名称</th>
            <th>景点介绍</th>
        </tr>
        </thead>
        <?php

        //var_dump($descr);
        foreach($descr as $point){
            $sql = "select title,descr from points where Vid = '{$point}';";
            mysqli_query($db,"SET NAMES 'utf8'");

            $result = $db->query($sql);
            if($result)
            {
                while($attr = $result->fetch_row())
                {
                    echo "<tr>
            <td style='font-weight: bold; font-size: larger;'>{$attr[0]}</td>
            <td>{$attr[1]}</td>
            </tr>";
                }
            }
        }
        ?>
    </table>
</div>



    <div class=" row justify-content-center">
        <a href="index.html">
            <button class="btn btn-primary">返回主页</button>
        </a>
    </div>

<div class="row justify-content-center footer-link my-5">
    <p>Copyright © 2018 董文杰  <a href="http://144.168.62.45" target="_blank" title="Personal Website">👉个人主页👈</a> </p>
</div>
</body>
</html>
