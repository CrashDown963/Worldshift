<?xml version="1.0"?>
<library id="Temple_Destruction" type="physics">
 <scenedesc source="3dsmax">
  <eye>0.56539 55.6978 36.7322</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.620021 54.8045 36.286</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="nothing">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-9.8824 6.55052 0.0</position>
   <shape id="shape_nothing">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="nothing_mat">
     <dynamicfriction>0.45</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.45</staticfriction>
    </physicsmaterial>
    <geometry id="nothing_geom">
     <sphere>
      <radius>1.30016</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
