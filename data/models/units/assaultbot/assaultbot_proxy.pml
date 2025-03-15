<?xml version="1.0"?>
<library id="AssaultBot_02_10" type="physics">
 <scenedesc source="3dsmax">
  <gravity>0.0 0.0 -10.0</gravity>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="pt_center">
   <mass>30.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>0.0141417 0.147111 0.986627</position>
   <shape id="shape_pt_center">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="pt_center_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="pt_center_geom">
     <sphere>
      <radius>1.18429</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
