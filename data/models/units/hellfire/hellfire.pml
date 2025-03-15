<?xml version="1.0"?>
<library id="HellFire_PhysXModel_BreakMesh_Scaled01" type="physics">
 <scenedesc source="3dsmax">
  <eye>-6.77173 0.876634 8.32158</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-6.08431 0.840608 7.59621</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bone_body">
   <mass>70.0</mass>
   <orientation>-0.572134 0.572133 -0.415528 -0.415528</orientation>
   <position>-0.00485055 -0.0369686 1.98232</position>
   <shape id="shape_Bone_body">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_body_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.05</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_body_geom">
     <convex facecount="0">
      <vertices count="12">
         -0.112304 0.179336 0.378088,
         -0.112304 -0.189036 0.378089,
         -0.412035 0.179335 -0.198094,
         -0.412035 -0.189037 -0.198094,
         1.248 0.229354 0.205745,
         1.248 -0.239055 0.205746,
         1.00948 0.229354 -0.52749,
         1.00948 -0.239055 -0.52749,
         0.682075 0.577105 0.389842,
         0.682075 -0.586805 0.389843,
         0.384077 -0.586805 -0.545294,
         0.384076 0.577104 -0.545295,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_foot_R1">
   <mass>15.0</mass>
   <orientation>-0.690893 0.150557 0.690892 -0.150557</orientation>
   <position>-0.551598 -0.00925125 1.67581</position>
   <shape id="shape_Bone_foot_R1">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_foot_R1_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_foot_R1_geom">
     <convex facecount="0">
      <vertices count="12">
         0.744023 0.105732 -0.131271,
         0.744023 0.105732 0.245913,
         0.518651 -0.419132 -0.131271,
         0.518651 -0.419132 0.245913,
         -0.00493606 0.157025 -0.336414,
         0.0144042 0.148175 0.245913,
         -0.0329874 -0.325186 -0.336415,
         0.0035704 -0.249216 0.245913,
         0.40882 0.113408 -0.303189,
         0.57017 0.118329 0.308321,
         0.320401 -0.400355 0.245912,
         0.312105 -0.337387 -0.310721,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_foot_R2">
   <mass>15.0</mass>
   <orientation>-0.686643 -0.168884 0.686642 0.168883</orientation>
   <position>-0.551597 -0.288522 1.06546</position>
   <shape id="shape_Bone_foot_R2">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_foot_R2_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_foot_R2_geom">
     <convex facecount="0">
      <vertices count="8">
         0.721877 0.178299 -0.25199,
         0.721877 0.178299 0.311731,
         0.853773 -0.344512 -0.25199,
         0.853772 -0.344511 0.311732,
         0.0815694 0.19074 -0.126968,
         0.0815693 0.19074 0.186708,
         0.347559 -0.260301 -0.126968,
         0.347559 -0.260301 0.186709,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_foot_R3">
   <mass>15.0</mass>
   <orientation>-0.56289 0.427967 0.562889 -0.427967</orientation>
   <position>-0.551596 0.110218 0.303901</position>
   <shape id="shape_Bone_foot_R3">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_foot_R3_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_foot_R3_geom">
     <convex facecount="0">
      <vertices count="8">
         0.70274 -0.120386 -0.201442,
         0.70274 -0.120386 0.273847,
         -0.299825 -0.398579 -0.161231,
         -0.299825 -0.398579 0.233635,
         0.654553 0.0532733 -0.158748,
         0.654553 0.0532732 0.231153,
         -0.315447 -0.0262759 -0.16123,
         -0.315447 -0.026276 0.233635,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_foot_L1">
   <mass>15.0</mass>
   <orientation>-0.69084 0.150799 0.690839 -0.150799</orientation>
   <position>0.57031 -0.00925125 1.67581</position>
   <shape id="shape_Bone_foot_L1">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_foot_L1_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_foot_L1_geom">
     <convex facecount="0">
      <vertices count="12">
         0.744023 0.105732 0.131271,
         0.744023 0.105732 -0.245913,
         0.518651 -0.419132 0.131271,
         0.518651 -0.419132 -0.245912,
         -0.00493606 0.157025 0.336414,
         0.0144042 0.148175 -0.245913,
         -0.0329874 -0.325186 0.336415,
         0.0035704 -0.249216 -0.245912,
         0.40882 0.113408 0.303189,
         0.57017 0.118329 -0.308321,
         0.320401 -0.400355 -0.245912,
         0.312105 -0.337387 0.310721,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_foot_L2">
   <mass>15.0</mass>
   <orientation>-0.686523 -0.169372 0.686522 0.169372</orientation>
   <position>0.570311 -0.288951 1.06566</position>
   <shape id="shape_Bone_foot_L2">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_foot_L2_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_foot_L2_geom">
     <convex facecount="0">
      <vertices count="8">
         0.721877 0.178299 0.251991,
         0.721877 0.178299 -0.311731,
         0.853773 -0.344512 0.25199,
         0.853772 -0.344511 -0.311732,
         0.0815694 0.19074 0.126968,
         0.0815693 0.19074 -0.186708,
         0.347559 -0.260301 0.126968,
         0.347559 -0.260301 -0.186709,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_foot_L3">
   <mass>15.0</mass>
   <orientation>-0.562891 0.427965 0.56289 -0.427965</orientation>
   <position>0.570311 0.110873 0.304665</position>
   <shape id="shape_Bone_foot_L3">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_foot_L3_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_foot_L3_geom">
     <convex facecount="0">
      <vertices count="8">
         0.70274 -0.120386 0.201442,
         0.70274 -0.120386 -0.273847,
         -0.299825 -0.398579 0.161231,
         -0.299825 -0.398579 -0.233635,
         0.654553 0.0532733 0.158748,
         0.654553 0.0532732 -0.231153,
         -0.315447 -0.0262759 0.161231,
         -0.315447 -0.026276 -0.233635,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_L_sholder">
   <mass>30.0</mass>
   <orientation>-0.697534 -0.11596 0.11596 -0.697534</orientation>
   <position>0.450668 -1.57561e-007 2.96801</position>
   <shape id="shape_Bone_L_sholder">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_L_sholder_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_L_sholder_geom">
     <convex facecount="0">
      <vertices count="12">
         0.0981793 -0.215727 0.349315,
         0.317047 -0.266649 0.354714,
         0.933534 -0.0297378 0.386227,
         0.119514 -0.189325 -0.266536,
         0.338381 -0.240247 -0.261137,
         0.954868 -0.00333546 -0.229624,
         -0.225258 0.0966437 0.333984,
         0.324041 0.309831 0.362152,
         0.732734 0.222563 0.383234,
         -0.206187 0.120245 -0.216532,
         0.343112 0.333432 -0.188364,
         0.75282 0.247421 -0.196583,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_L_hand_1">
   <mass>15.0</mass>
   <orientation>0.70445 0.061238 -0.70445 -0.061238</orientation>
   <position>0.99508 -0.0452924 2.7075</position>
   <shape id="shape_Bone_L_hand_1">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_L_hand_1_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_L_hand_1_geom">
     <convex facecount="0">
      <vertices count="8">
         0.139867 -0.115029 0.273674,
         0.139867 -0.115029 -0.103944,
         0.0577669 0.166896 0.273674,
         0.0577669 0.166896 -0.103943,
         0.80938 -0.0660878 0.103943,
         0.80938 -0.0660878 -0.103944,
         0.486837 0.155684 0.103943,
         0.486837 0.155684 -0.103944,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_L_hand_2">
   <mass>15.0</mass>
   <orientation>-0.506 0.510772 0.489154 -0.493765</orientation>
   <position>0.933296 0.149291 1.95408</position>
   <shape id="shape_Bone_L_hand_2">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_L_hand_2_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_L_hand_2_geom">
     <convex facecount="0">
      <vertices count="12">
         0.151423 -0.15931 0.145866,
         0.151423 -0.15931 -0.145865,
         0.222243 0.175694 0.145866,
         0.222243 0.175694 -0.145865,
         1.57654 -0.138673 0.145866,
         1.57654 -0.138673 -0.145865,
         1.57654 0.138673 0.145866,
         1.57654 0.138673 -0.145865,
         0.690068 -0.25998 0.145865,
         0.583014 -0.110698 -0.338469,
         0.583014 0.166647 -0.338469,
         0.70809 0.1496 0.145865,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_R_sholder">
   <mass>30.0</mass>
   <orientation>0.127478 0.695521 -0.695521 0.127478</orientation>
   <position>-0.425717 0.0 2.98467</position>
   <shape id="shape_Bone_R_sholder">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_R_sholder_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_R_sholder_geom">
     <convex facecount="0">
      <vertices count="12">
         0.0981793 0.215728 0.349315,
         0.317047 0.266649 0.354714,
         0.933534 0.0297379 0.386227,
         0.119514 0.189325 -0.266536,
         0.338381 0.240247 -0.261137,
         0.954868 0.00333559 -0.229624,
         -0.225258 -0.0966436 0.333984,
         0.324041 -0.309831 0.362152,
         0.732734 -0.222563 0.383234,
         -0.206187 -0.120245 -0.216532,
         0.343112 -0.333432 -0.188364,
         0.75282 -0.24742 -0.196583,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_R_hand_1">
   <mass>15.0</mass>
   <orientation>0.704572 0.059815 -0.704572 -0.0598146</orientation>
   <position>-0.993903 -0.039081 2.66608</position>
   <shape id="shape_Bone_R_hand_1">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_R_hand_1_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_R_hand_1_geom">
     <convex facecount="0">
      <vertices count="8">
         0.139867 -0.115029 -0.273674,
         0.139867 -0.115029 0.103943,
         0.0577669 0.166896 -0.273674,
         0.0577669 0.166896 0.103943,
         0.80938 -0.0660878 -0.103943,
         0.80938 -0.0660878 0.103944,
         0.486837 0.155684 -0.103943,
         0.486837 0.155684 0.103944,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_R_hand_2">
   <mass>20.0</mass>
   <orientation>0.512024 -0.504734 -0.494976 0.487929</orientation>
   <position>-0.882964 0.174441 1.86452</position>
   <shape id="shape_Bone_R_hand_2">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_R_hand_2_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_R_hand_2_geom">
     <convex facecount="0">
      <vertices count="12">
         1.41558 -0.176446 0.130495,
         1.41558 -0.176446 -0.164089,
         0.809559 -0.338414 0.130495,
         0.809559 -0.338414 -0.226068,
         0.331433 -0.108909 0.283341,
         0.165225 -0.0398721 -0.164089,
         1.26113 0.149216 0.130495,
         1.34674 0.139611 -0.164089,
         0.685817 0.170834 0.416991,
         1.01286 0.285401 -0.139446,
         0.271246 0.164092 0.373603,
         0.169209 0.280321 -0.164089,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_guz">
   <mass>20.0</mass>
   <orientation>-0.497745 -0.502245 0.502249 -0.49774</orientation>
   <position>0.00471334 0.0 1.69887</position>
   <shape id="shape_Bone_guz">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_guz_mat">
     <dynamicfriction>0.7</dynamicfriction>
     <restitution>0.3</restitution>
     <staticfriction>0.7</staticfriction>
    </physicsmaterial>
    <geometry id="Bone_guz_geom">
     <convex facecount="0">
      <vertices count="8">
         -0.0755114 -0.300104 0.0944868,
         0.250713 -0.165632 -0.116304,
         -0.0780062 0.306425 0.0944844,
         0.250713 0.163995 -0.116304,
         -0.0884223 -0.303611 0.58753,
         0.420942 -0.16594 0.316168,
         -0.0909171 0.302918 0.587527,
         0.420942 0.163687 0.316168,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Tank_Right">
   <mass>20.0</mass>
   <orientation>0.0 0.0 0.0 -1.0</orientation>
   <position>-0.399057 0.5795 2.86143</position>
   <shape id="shape_Tank_Right">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Tank_Right_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.4</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 -0.519085</position>
    <geometry id="Tank_Right_geom">
     <capsule>
      <p0>0.0 0.0 0.215904</p0>
      <p1>0.0 0.0 0.822266</p1>
      <radius>0.215904</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Tank_Right_Box">
   <mass>15.0</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.424482 0.620474 2.33578</position>
   <shape id="shape_Tank_Right_Box">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Tank_Right_Box_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.35</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Tank_Right_Box_geom">
     <box>
      <size>0.552033 0.566018 0.178437</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Tank_Bottom">
   <mass>20.0</mass>
   <orientation>0.0 0.707107 0.0 -0.707107</orientation>
   <position>-0.0014815 0.573276 1.96404</position>
   <shape id="shape_Tank_Bottom">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Tank_Bottom_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.35</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 -0.467691</position>
    <geometry id="Tank_Bottom_geom">
     <capsule>
      <p0>0.0 0.0 0.195146</p0>
      <p1>0.0 0.0 0.740236</p1>
      <radius>0.195146</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Tank_Bottom_Box">
   <mass>15.0</mass>
   <orientation>0.0 -3.79322e-007 0.0 1.0</orientation>
   <position>0.028363 0.882111 2.02556</position>
   <shape id="shape_Tank_Bottom_Box">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Tank_Bottom_Box_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.35</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Tank_Bottom_Box_geom">
     <box>
      <size>1.12321 0.154154 0.436119</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="ChestPlate_Left">
   <mass>15.0</mass>
   <orientation>-0.537217 0.00942547 0.014795 0.843262</orientation>
   <position>0.362298 -0.490175 2.33356</position>
   <shape id="shape_ChestPlate_Left">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="ChestPlate_Left_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="ChestPlate_Left_geom">
     <box>
      <size>0.266207 0.61269 0.0815997</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="ChestPlate_Right">
   <mass>15.0</mass>
   <orientation>-0.843262 0.014795 -0.00942554 -0.537217</orientation>
   <position>-0.362298 -0.490175 2.33356</position>
   <shape id="shape_ChestPlate_Right">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="ChestPlate_Right_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.8</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="ChestPlate_Right_geom">
     <box>
      <size>0.266207 0.61269 0.0815997</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Tank_Left">
   <mass>20.0</mass>
   <orientation>0.0 0.0 0.0 -1.0</orientation>
   <position>0.435707 0.5795 2.86143</position>
   <shape id="shape_Tank_Left">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Tank_Left_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.4</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 -0.519085</position>
    <geometry id="Tank_Left_geom">
     <capsule>
      <p0>0.0 0.0 0.215904</p0>
      <p1>0.0 0.0 0.822266</p1>
      <radius>0.215904</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Tank_Right_Box" class="novodex" id="Joint_Tank_Right_Box" parent="#Tank_Right">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>1.0 -1.61815e-007 1.54558e-007</x>
    <y>1.61815e-007 1.0 0.0</y>
    <z>-1.54558e-007 0.0 1.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.02034 0.0327792 -0.420513</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Tank_Bottom_Box" class="novodex" id="Joint_Tank_Bottom_Box" parent="#Tank_Bottom">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>4.21468e-007 0.0 1.0</x>
    <y>0.0 1.0 0.0</y>
    <z>-1.0 0.0 4.17233e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0492097 0.247068 -0.0238756</offset>
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
