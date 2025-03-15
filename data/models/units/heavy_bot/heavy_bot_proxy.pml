<?xml version="1.0"?>
<library id="Heavy_Bot_BH" type="physics">
 <scenedesc source="3dsmax">
  <eye>-2.10648 -11.0026 3.63788</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-1.90112 -10.0365 3.48144</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="ROOT">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.0923719 -0.286361 -0.0797263</position>
   <shape id="shape_ROOT">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="ROOT_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.35</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="ROOT_geom">
     <capsule>
      <p0>0.0 0.0 1.59407</p0>
      <p1>0.0 0.0 2.26963</p1>
      <radius>1.59407</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
