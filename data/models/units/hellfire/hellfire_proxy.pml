<?xml version="1.0"?>
<library id="HellFire_PhysXModel_BreakMesh_Scaled01" type="physics">
 <scenedesc source="3dsmax">
  <eye>-8.0135 -9.21165 2.49453</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-7.47184 -8.37758 2.39</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bone_guz">
   <mass>10.0</mass>
   <orientation>-0.5 -0.5 -0.5 -0.5</orientation>
   <position>0.022031 0.106742 0.0</position>
   <shape id="shape_Bone_guz">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_guz_mat">
     <dynamicfriction>0.5</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.5</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_guz_geom">
     <capsule>
      <p0>0.0 0.0 1.19176</p0>
      <p1>0.0 0.0 2.50805</p1>
      <radius>1.19176</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
