<?xml version="1.0"?>
<library id="Gad_new_idle_camerasPhysX2" type="physics">
 <scenedesc source="3dsmax">
  <eye>8.37801 -10.9645 3.6618</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>7.74803 -10.1956 3.5525</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>55.0</mass>
   <orientation>0.125598 0.119672 -0.699111 0.693648</orientation>
   <position>0.0312417 0.684983 2.58838</position>
   <shape id="shape_Bip01_Spine">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine_geom">
     <capsule>
      <p0>0.0 0.0 0.679874</p0>
      <p1>0.0 0.0 0.889297</p1>
      <radius>0.679874</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>20.0</mass>
   <orientation>-0.591144 0.764996 -0.0844921 -0.241227</orientation>
   <position>-0.276277 0.806989 2.33985</position>
   <shape id="shape_Bip01_R_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.35</p0>
      <p1>0.0 0.0 0.85</p1>
      <radius>0.35</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>15.0</mass>
   <orientation>0.577134 -0.798423 -0.153316 -0.0770136</orientation>
   <position>-0.587513 0.327764 1.33469</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.26</p0>
      <p1>0.0 0.0 1.14</p1>
      <radius>0.26</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>20.0</mass>
   <orientation>-0.749592 0.594764 -0.266546 -0.115411</orientation>
   <position>0.344142 0.777 2.33912</position>
   <shape id="shape_Bip01_L_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.35</p0>
      <p1>0.0 0.0 0.85</p1>
      <radius>0.35</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>15.0</mass>
   <orientation>-0.794024 0.592245 0.0496156 0.12771</orientation>
   <position>0.647439 0.210347 1.37799</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.26</p0>
      <p1>0.0 0.0 1.14</p1>
      <radius>0.26</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>25.0</mass>
   <orientation>0.797615 0.372631 0.448453 0.154426</orientation>
   <position>0.929382 0.234119 3.58448</position>
   <shape id="shape_Bip01_L_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.3813</p0>
      <p1>0.0 0.0 0.5178</p1>
      <radius>0.3813</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>12.0</mass>
   <orientation>-0.914807 -0.241904 0.0206556 -0.322775</orientation>
   <position>1.65672 0.354557 3.15323</position>
   <shape id="shape_Bip01_L_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.22</p0>
      <p1>0.0 0.0 0.91</p1>
      <radius>0.22</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Hand">
   <mass>3.5</mass>
   <orientation>-0.162673 -0.947906 0.273862 -0.00326284</orientation>
   <position>1.7902 -0.322661 2.26149</position>
   <shape id="shape_Bip01_L_Hand">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Hand_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Hand_geom">
     <capsule>
      <p0>0.0 0.0 0.244613</p0>
      <p1>0.0 0.0 0.472857</p1>
      <radius>0.244613</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm">
   <mass>12.0</mass>
   <orientation>-0.205769 -0.827356 0.203991 0.481174</orientation>
   <position>-0.857156 0.169262 3.56423</position>
   <shape id="shape_Bip01_R_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.3379</p0>
      <p1>0.0 0.0 0.5221</p1>
      <radius>0.3379</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>12.0</mass>
   <orientation>-0.0915381 -0.955468 0.274907 0.055921</orientation>
   <position>-1.6604 0.113902 3.26199</position>
   <shape id="shape_Bip01_R_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.22</p0>
      <p1>0.0 0.0 0.91</p1>
      <radius>0.22</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Hand">
   <mass>3.5</mass>
   <orientation>0.957827 0.150666 0.0131958 0.244322</orientation>
   <position>-1.83766 -0.466952 2.31182</position>
   <shape id="shape_Bip01_R_Hand">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Hand_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Hand_geom">
     <capsule>
      <p0>0.0 0.0 0.244613</p0>
      <p1>0.0 0.0 0.472857</p1>
      <radius>0.244613</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head">
   <mass>20.0</mass>
   <orientation>0.124697 0.184902 -0.67415 0.704118</orientation>
   <position>0.0341501 -0.320476 3.77079</position>
   <shape id="shape_Bip01_Head">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Head_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 1.33514e-007 0.0669579</position>
    <geometry id="Bip01_Head_geom">
     <sphere>
      <radius>0.3744</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>10.0</mass>
   <orientation>0.0627718 -3.67395e-005 -0.616151 0.785122</orientation>
   <position>0.0339323 0.791995 2.33949</position>
   <shape id="shape_Bip01_Pelvis">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Pelvis_geom">
     <sphere>
      <radius>0.0295858</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.652621 -0.317008 0.68818</x>
    <y>-0.173635 -0.94667 -0.271418</y>
    <z>0.737521 0.0576413 -0.67286</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.027865 -0.310322 -0.272292</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>15.6468 33.1225 23.9758</rotlimitmax>
   <rotlimitmin>-15.6468 -33.1225 -7.55292</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf" class="novodex" id="Joint_Bip01_R_Calf" parent="#Bip01_R_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.694376 0.0 0.719613</x>
    <y>-0.719613 0.0 -0.694376</y>
    <z>0.0 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -1.39475e-007 1.15623</offset>
    <x>-1.0 -4.92769e-007 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>4.92769e-007 -1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 75.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -30.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh" class="novodex" id="Joint_Bip01_L_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.595828 0.304946 0.742964</x>
    <y>0.161643 -0.951711 0.260994</y>
    <z>0.786677 -0.0354132 -0.616349</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00325288 0.310322 -0.26868</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>13.5499 33.2454 9.39557</rotlimitmax>
   <rotlimitmin>-13.5499 -33.2454 -14.5427</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf" class="novodex" id="Joint_Bip01_L_Calf" parent="#Bip01_L_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.690874 0.0 0.722975</x>
    <y>-0.722975 0.0 -0.690874</y>
    <z>0.0 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-1.68216e-007 2.94376e-007 1.15623</offset>
    <x>-1.0 0.0 0.0</x>
    <y>0.0 -1.72803e-007 -1.0</y>
    <z>0.0 -1.0 1.72803e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 75.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -30.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm" class="novodex" id="Joint_Bip01_L_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.895876 0.432849 0.100234</x>
    <y>0.317559 0.466024 0.82582</y>
    <z>0.310744 0.771663 -0.554955</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0778967 0.909054 1.08153</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>57.9946 33.6901 0.0</rotlimitmax>
   <rotlimitmin>-57.9946 -33.6901 -71.948</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.480529 0.0 0.876979</x>
    <y>-0.876979 0.0 -0.480529</y>
    <z>0.0 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0621976 2.4778e-007 0.851839</offset>
    <x>-1.0 1.54851e-007 0.0</x>
    <y>0.0 -9.38349e-007 -1.0</y>
    <z>-1.54851e-007 -1.0 9.38349e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 24.9802</rotlimitmax>
   <rotlimitmin>0.0 0.0 -25.0198</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Hand" class="novodex" id="Joint_Bip01_L_Hand" parent="#Bip01_L_Forearm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-4.91877e-007 0.999454 0.0330548</x>
    <y>-3.9954e-007 0.0330548 -0.999454</y>
    <z>-1.0 -2.35684e-007 3.91964e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-7.62939e-007 -2.67029e-007 1.12767</offset>
    <x>0.711519 -0.702667 0.0</x>
    <y>0.15521 0.157165 -0.9753</y>
    <z>0.685311 0.693944 0.220887</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 27.7927</rotlimitmax>
   <rotlimitmin>0.0 0.0 -25.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.745037 -0.599932 0.291552</x>
    <y>-0.452173 0.132924 -0.88197</y>
    <z>0.490367 -0.788932 -0.370306</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.156764 -0.87692 1.1018</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>56.3099 51.8428 66.9818</rotlimitmax>
   <rotlimitmin>-56.3099 -51.8428 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.592522 0.0 0.805554</x>
    <y>-0.805554 0.0 -0.592522</y>
    <z>0.0 -1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.118282 0.0 0.851839</offset>
    <x>-1.0 -3.89414e-007 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>3.89414e-007 -1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 25.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -25.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Hand" class="novodex" id="Joint_Bip01_R_Hand" parent="#Bip01_R_Forearm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-3.1529e-007 -0.999925 -0.0122869</x>
    <y>0.0 0.0122869 -0.999925</y>
    <z>1.0 -3.64864e-007 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 1.52588e-007 1.12767</offset>
    <x>0.423717 0.905795 0.0</x>
    <y>0.236643 -0.110698 -0.96527</y>
    <z>-0.874336 0.409001 -0.261255</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 25.0001</rotlimitmax>
   <rotlimitmin>0.0 0.0 -24.9999</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.995142 -0.0372853 0.0911157</x>
    <y>0.027887 0.99436 0.102326</y>
    <z>-0.0944171 -0.0992883 0.990569</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.540973 0.0201944 1.45464</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>2.75315 29.8464 24.8195</rotlimitmax>
   <rotlimitmin>-2.75315 -29.8464 -24.7285</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis" class="novodex" id="Joint_Bip01_Pelvis" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.934207 -0.258466 -0.245873</x>
    <y>0.248933 0.966013 -0.0696551</y>
    <z>0.25552 0.00386637 0.966796</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.015559 0.0 -0.270486</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
