<?xml version="1.0"?>
<library id="RocketLaucher_Rig_Anim2_Phys1" type="physics">
 <scenedesc source="3dsmax">
  <eye>-245.924 -77.5168 71.3404</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-245.003 -77.2262 71.0804</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="_Tire_RL">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>2.51029 2.76094 1.39335</position>
   <shape id="shape__Tire_RL">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <geometry id="_Tire_RL_geom">
     <sphere>
      <radius>1.38465</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="_Tire_RR">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-2.56481 2.76094 1.39335</position>
   <shape id="shape__Tire_RR">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <geometry id="_Tire_RR_geom">
     <sphere>
      <radius>1.38465</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="_Tire_FR">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-2.56481 -3.12454 1.39596</position>
   <shape id="shape__Tire_FR">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <geometry id="_Tire_FR_geom">
     <sphere>
      <radius>1.38465</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="_Tire_FL">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>2.51029 -3.12454 1.39596</position>
   <shape id="shape__Tire_FL">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <geometry id="_Tire_FL_geom">
     <sphere>
      <radius>1.38465</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Chasis">
   <mass>10.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.00665581 0.0289752 2.07775</position>
   <shape id="shape_Chasis">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <position>0.0 0.0 0.139314</position>
    <geometry id="Chasis_geom">
     <box>
      <size>2.37446 2.75865 0.278628</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
