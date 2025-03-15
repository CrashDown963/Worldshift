<?xml version="1.0"?>
<library id="Brute_PhysX02" type="physics">
 <scenedesc source="3dsmax">
  <eye>0.485751 -3.69679 1.4903</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.356498 -2.71499 1.35112</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>40.0</mass>
   <orientation>0.0626727 0.0729498 -0.858747 0.503294</orientation>
   <position>0.0558773 0.0421394 1.36766</position>
   <shape id="shape_Bip01_Spine">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine_geom">
     <capsule>
      <p0>0.0 0.0 0.3549</p0>
      <p1>0.0 0.0 0.484447</p1>
      <radius>0.3549</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>20.0</mass>
   <orientation>-0.822962 0.52166 -0.19774 -0.10725</orientation>
   <position>0.269622 -0.0855301 1.22364</position>
   <shape id="shape_Bip01_L_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.2</p0>
      <p1>0.0 0.0 0.45</p1>
      <radius>0.2</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>10.0</mass>
   <orientation>-0.846229 0.531843 0.0162888 0.027834</orientation>
   <position>0.404605 -0.32749 0.655576</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.165</p0>
      <p1>0.0 0.0 0.505</p1>
      <radius>0.165</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>10.0</mass>
   <orientation>0.909247 0.244811 0.26451 0.208261</orientation>
   <position>0.460453 -0.173799 1.96796</position>
   <shape id="shape_Bip01_L_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.145</p0>
      <p1>0.0 0.0 0.285</p1>
      <radius>0.145</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>10.0</mass>
   <orientation>-0.939146 -0.209796 -0.121244 -0.243497</orientation>
   <position>0.712482 -0.281537 1.63364</position>
   <shape id="shape_Bip01_L_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.123</p0>
      <p1>0.0 0.0 0.567</p1>
      <radius>0.123</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm">
   <mass>10.0</mass>
   <orientation>-0.516981 -0.739661 -0.0598054 0.426679</orientation>
   <position>-0.34016 0.0613807 2.04912</position>
   <shape id="shape_Bip01_R_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.145</p0>
      <p1>0.0 0.0 0.285</p1>
      <radius>0.145</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>10.0</mass>
   <orientation>-0.516764 -0.818415 0.0616502 0.243619</orientation>
   <position>-0.565783 0.271264 1.79997</position>
   <shape id="shape_Bip01_R_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.123</p0>
      <p1>0.0 0.0 0.567</p1>
      <radius>0.123</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head">
   <mass>20.0</mass>
   <orientation>0.0690439 0.0969414 -0.708165 0.695943</orientation>
   <position>0.0269547 -0.210414 2.13348</position>
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
      <radius>0.1664</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>10.0</mass>
   <orientation>0.0139248 0.0250463 -0.873576 0.485844</orientation>
   <position>0.067796 0.039589 1.23082</position>
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
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.630973 0.726612 -0.0439745 0.268281</orientation>
   <position>0.326915 -0.227769 1.64884</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.145</p0>
      <p1>0.0 0.0 0.285</p1>
      <radius>0.145</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.74073 -0.270905 0.460851 -0.406875</orientation>
   <position>0.471472 -0.401758 1.28043</position>
   <shape id="shape_Bip01_L_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.123</p0>
      <p1>0.0 0.0 0.567</p1>
      <radius>0.123</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm02">
   <mass>10.0</mass>
   <orientation>-0.58899 0.430673 -0.409259 0.547831</orientation>
   <position>-0.265754 0.136816 1.70683</position>
   <shape id="shape_Bip01_R_UpperArm02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm02_mat">
     <dynamicfriction>0.5</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.5</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm02_geom">
     <convex facecount="0">
      <vertices count="8">
         -0.127092 -0.10985 -0.452436,
         0.127092 -0.10985 -0.452436,
         -0.127092 0.10985 -0.452436,
         0.127092 0.10985 -0.452436,
         -0.127092 -0.10985 0.0351702,
         0.127092 -0.10985 0.0351702,
         -0.127092 0.10985 0.0351702,
         0.127092 0.10985 0.0351702,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm02">
   <mass>10.0</mass>
   <orientation>-0.582071 0.1866 0.0419961 0.790322</orientation>
   <position>-0.678169 0.0102252 1.73483</position>
   <shape id="shape_Bip01_R_Forearm02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm02_mat">
     <dynamicfriction>0.5</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.5</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm02_geom">
     <convex facecount="0">
      <vertices count="8">
         -0.127092 -0.10985 -0.452436,
         0.127092 -0.10985 -0.452436,
         -0.127092 0.10985 -0.452436,
         0.127092 0.10985 -0.452436,
         -0.127092 -0.10985 0.0351702,
         0.127092 -0.10985 0.0351702,
         -0.127092 0.10985 0.0351702,
         0.127092 0.10985 0.0351702,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>20.0</mass>
   <orientation>-0.389067 0.911084 0.00933502 -0.135888</orientation>
   <position>-0.13403 0.164708 1.238</position>
   <shape id="shape_Bip01_R_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.2</p0>
      <p1>0.0 0.0 0.45</p1>
      <radius>0.2</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>10.0</mass>
   <orientation>0.374125 -0.915894 -0.107194 -0.0983735</orientation>
   <position>-0.295118 0.108629 0.629426</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.165</p0>
      <p1>0.0 0.0 0.505</p1>
      <radius>0.165</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_gun">
   <mass>20.0</mass>
   <orientation>0.0296457 -0.0503781 -0.261582 0.96341</orientation>
   <position>-0.36977 -0.500935 1.14507</position>
   <shape id="shape_Bone_gun">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_gun_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.35</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_gun_geom">
     <convex facecount="0">
      <vertices count="16">
         -0.620938 -0.213943 0.444134,
         -0.624031 -0.531065 -0.0749832,
         -0.620937 0.343554 0.315369,
         -0.624031 0.0521798 -0.354745,
         -0.0825288 -0.213943 0.441595,
         -0.0856225 -0.531065 -0.0775217,
         -0.0825287 0.343554 0.312831,
         -0.0856224 0.0521798 -0.357283,
         0.307759 -0.0649611 0.248019,
         0.306253 -0.21931 -0.0910127,
         0.307759 0.206383 0.185347,
         0.306253 0.064566 -0.227178,
         1.31153 -0.0487416 0.093742,
         1.31046 -0.159253 -0.0871618,
         1.31153 0.145537 0.0488696,
         1.31046 0.043998 -0.184654,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_L_Thigh" class="novodex" id="Joint_Bip01_L_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.435559 0.812976 0.386469</x>
    <y>0.69661 -0.576335 0.427284</y>
    <z>0.570107 0.0831106 -0.817356</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0314877 0.257308 -0.124619</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>29.7449 34.6952 1.4856</rotlimitmax>
   <rotlimitmin>-29.7449 -34.6952 -36.3315</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf" class="novodex" id="Joint_Bip01_L_Calf" parent="#Bip01_L_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.872691 0.0 -0.488273</x>
    <y>-0.488273 0.0 -0.872691</y>
    <z>0.0 1.0 -1.278e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.632028</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm" class="novodex" id="Joint_Bip01_L_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.903006 0.423869 0.0701098</x>
    <y>0.354927 0.644042 0.67767</y>
    <z>0.24209 0.636824 -0.732016</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.120448 0.420318 0.616033</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>62.0812 31.1647 22.6199</rotlimitmax>
   <rotlimitmin>-62.0812 -31.1647 -15.9454</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.952504 0.00424952 -0.304498</x>
    <y>-0.304507 0.00169034 -0.952509</y>
    <z>-0.003533 0.99999 0.00290407</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>3.24011e-007 2.1713e-007 0.432314</offset>
    <x>0.999991 0.00424959 0.0</x>
    <y>-7.17947e-006 0.00168943 -0.999999</y>
    <z>-0.00424958 0.99999 0.00168945</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -70.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.686716 -0.724218 -0.0626911</x>
    <y>-0.476205 0.513347 -0.713936</y>
    <z>0.549227 -0.460417 -0.697399</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.052441 -0.397637 0.678781</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>67.9139 16.4223 44.9685</rotlimitmax>
   <rotlimitmin>-67.9139 -16.4223 -29.9722</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.892554 -2.08055e-007 -0.450941</x>
    <y>-0.450941 8.25423e-007 -0.892554</y>
    <z>5.57918e-007 1.0 6.42914e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-1.96812e-007 0.0 0.396274</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.884288 -0.466908 0.00564504</x>
    <y>0.464816 0.881349 0.0846773</y>
    <z>-0.0445117 -0.0722552 0.996392</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.091375 0.0490165 0.800215</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>13.2734 44.9509 60.1279</rotlimitmax>
   <rotlimitmin>-13.2734 -44.9509 -58.2167</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis" class="novodex" id="Joint_Bip01_Pelvis" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.990328 0.0434193 -0.131779</x>
    <y>-0.0483487 0.998237 -0.0344388</y>
    <z>0.130051 0.0404771 0.990681</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0211718 0.0201549 -0.134235</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm01" class="novodex" id="Joint_Bip01_L_UpperArm01" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.65437 -0.677344 0.336161</x>
    <y>-0.455793 0.708031 0.539394</y>
    <z>-0.603367 0.199743 -0.772043</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0483303 0.349571 0.317547</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>62.0812 31.1647 22.6199</rotlimitmax>
   <rotlimitmin>-62.0812 -31.1647 -15.9454</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm01" class="novodex" id="Joint_Bip01_L_Forearm01" parent="#Bip01_L_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.400814 -0.667034 -0.628023</x>
    <y>-0.90208 -0.167622 -0.397688</y>
    <z>0.160001 0.725926 -0.668904</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>2.62498e-007 0.0 0.432314</offset>
    <x>0.999991 0.00424959 0.0</x>
    <y>-7.17947e-006 0.00168943 -0.999999</y>
    <z>-0.00424958 0.99999 0.00168945</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -70.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm02" class="novodex" id="Joint_Bip01_R_UpperArm02" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.672774 0.23392 -0.701895</x>
    <y>0.717614 0.0245124 0.69601</y>
    <z>0.180015 -0.971947 -0.151373</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.013777 -0.347763 0.326065</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 30.9638</rotlimitmax>
   <rotlimitmin>0.0 0.0 -28.6105</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm02" class="novodex" id="Joint_Bip01_R_Forearm02" parent="#Bip01_R_UpperArm02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.413195 -0.397389 -0.81936</x>
    <y>0.292839 0.909953 -0.293651</y>
    <z>0.862273 -0.118606 0.492359</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 -0.432314</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>34.992 38.6598 30.9638</rotlimitmax>
   <rotlimitmin>-34.992 -38.6598 -28.6105</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.885593 -0.275424 0.373988</x>
    <y>-0.248308 -0.96123 -0.119914</y>
    <z>0.392516 0.0133306 -0.919649</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.010856 -0.216998 -0.143851</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>19.9831 12.9946 1.4856</rotlimitmax>
   <rotlimitmin>-19.9831 -12.9946 -22.6199</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf" class="novodex" id="Joint_Bip01_R_Calf" parent="#Bip01_R_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.872691 0.0 -0.488273</x>
    <y>-0.488273 0.0 -0.872691</y>
    <z>0.0 1.0 -1.278e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.632028</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
