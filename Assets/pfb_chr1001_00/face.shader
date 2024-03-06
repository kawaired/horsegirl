Shader "Unlit/face"
{
    Properties
    {
        _LightTex("lighttex",2D)="white"{}
        _DarkTex("darktex",2D)="white"{}
        _RimTex("rimtex",2D)="white"{}
        _FoldTex("foldtex",2D)="white"{}
        _MatCabTex("matcabtex",2D)="White"{}
        _NormalOffset("normaloffset",range(0,1))=0
        _DiffuseLight("diffuselight",color)=(0.2,0.2,0.2,0.2)
        _DiffuseRate("diffuserate",range(0,1))=0.9
        _DiffusePow("diffusepow",range(0.01,1))=0.5
        _DiffuseOffset("diffuseoffset",range(0.01,0.499))=0.1
        
        _SpecularLight("specularlight",color)=(0.4,0.4,0.4,0.4)
        _SpecularRate("specularrate",range(0,1))=1

        _RimHOffset1("rimhoffset1",range(-1,1))=0
        _RimVOffset1("rimvoffset1",range(-1,1))=0
        _RimColor1("rimcolor1",color)=(0.3,0.3,0.3,0.3)
        _RimHOffset2("rimhoffset2",range(-1,1))=0
        _RimVOffset2("rimvoffset2",range(-1,1))=0
        _RimColor2("rimcolor2",color)=(0.3,0.3,0.3,0.3)
        _RimPow("rimpow",range(1,20))=1
        _FresnelOffset("fresneloffset",range(0,1))=0

        _EyeTex("eyetex",2D)="white"{}
        _EyeSpecTex("eyespectex",2D)="white"{}
        _EyeParam1("eyeparam1",float)=(0.3,0.3,0.3)
        _EyeParam2("eyeparam2",float)=(0.2,0.2,0.2)
        _UVOffset("uvoffset",range(0,1))=0
        _UVTest("uvtest",range(1,10))=1
        _UVBack("UVBack",range(0,1))=0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 color:Color;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 worldvertex:TEXCOORD1;
                float3 worldnormal:TEXCOORD2;
                float3 viewnormal:TEXCOORD3;
                float4 color:COLOR;
            };

            sampler2D _LightTex;
            float4 _LightTex_ST;
            sampler2D  _DarkTex;
            float4 _DarkMain_ST;
            sampler2D _RimTex;
            float4 _RimTex_ST;
            sampler2D _FoldTex;
            float4 _FoldTex_ST;
            sampler2D _MatCabTex;
            float4 _MatCabTex_ST;
            float _NormalOffset;
            float4 _DiffuseLight;
            float _DiffuseRate;
            float _DiffusePow;
            float _DiffuseOffset;
            float4 _SpecularLight;
            float _SpecularRate;
            float _RimHOffset1;
            float _RimVOffset1;
            float4 _RimColor1;
            float _RimHOffset2;
            float _RimVOffset2;
            float4 _RimColor2;
            float _RimPow;
            float _FresnelOffset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _LightTex);
                o.worldvertex=mul((float4x4)unity_ObjectToWorld,v.vertex);
                float3 lerpnormal=lerp(v.normal.xzy,float3(normalize(v.vertex.xyz).xz,0),_NormalOffset);
                o.worldnormal=UnityObjectToWorldNormal(lerpnormal.xzy);
                // o.worldnormal=lerp(UnityObjectToWorldNormal(v.normal),float3(normalize(o.worldvertex.xyz).xy,0),_NormalOffset);
                o.viewnormal=mul(UNITY_MATRIX_IT_MV,lerpnormal.xzy);
                o.color=v.color;
                return o;
            }

            float3 OffsetVector(float3 origionvector,float3 aimvector,float offsetvalue)
            {
                return  lerp(origionvector,aimvector*((offsetvalue>=0)-(offsetvalue<0)),abs(offsetvalue));
            }

            float ZeroStep(float x)
            {
                return (x>=0)-(x<0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 lighttex=tex2D(_LightTex,i.uv);
                // return lighttex;
                float4 darktex=tex2D(_DarkTex,i.uv);
                float4 rimtex=tex2D(_RimTex,i.uv);//y轴表示材质的区分
                //return rimtex.y;
                float4 foldtex=tex2D(_FoldTex,i.uv);//x轴漫反射容易出现阴影的区域的程度，y轴表示金属区域的高光反射显示区域
                //return foldtex.y;

                float lambert=dot(i.worldnormal,_WorldSpaceLightPos0);
                float lambertfactor=0.5*(lambert+1)*foldtex.x;
                lambertfactor=lambertfactor*2-1;
                lambertfactor=0.5*(ZeroStep(lambertfactor)*pow(abs(lambertfactor),_DiffusePow)+1);
                float4 diffusecolor=lerp(darktex,lighttex, smoothstep(0.5-_DiffuseOffset,0.5+_DiffuseOffset,lambertfactor));

                float4 matcabtex=tex2D(_MatCabTex,(i.viewnormal.xy+float2(1,1))*0.5);
                float4 specularcolor=rimtex.y*matcabtex*_SpecularLight*_SpecularRate;
                //return specularcolor;

                float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex.xyz);
                float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
                float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
                float3 offsetviewdir1=OffsetVector(viewdir,camxdir,_RimHOffset1);
                offsetviewdir1=OffsetVector(offsetviewdir1,camydir,_RimVOffset1);
                float fresnel1=dot(offsetviewdir1,i.worldnormal);
                //return (fresnel1>0.95);//*rimtex.z*_RimColor;
                fresnel1=pow(saturate(_FresnelOffset-fresnel1),_RimPow);
                //return fresnel1;
                //float4 rimcolor1=(fresnel1>0.9)*rimtex.z*_RimColor1;
                return diffusecolor+specularcolor;
                // return rimcolor1;
                // return lerp(diffusecolor+specularcolor,rimcolor1,(fresnel1>=0.9)*rimtex.z);
            }
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv :TEXCOORD0;
                float2 uv2:TEXCOORD1;
                float2 uv3:TEXCOORD2;
            };

            struct v2f
            {
                float2 uv:TEXCOORD0;
                float2 uv2:TEXCOORD1;
                float2 uv3:TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _EyeTex;
            float4 _EyeTex_ST;
            sampler2D _EyeSpecTex;
            float4 _EyeSpecTex_ST;
            float3 _EyeParam1;
            float3 _EyeParam2;

            float _UVOffset;
            float _UVTest;
            float _UVBack;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //float vertexw=pow(o.vertex.w*0.005+1,);
                //o.uv=TRANSFORM_TEX(v.uv,_EyeTex);
                float2 uv1=v.uv-float2(0.5,0.5);
                uv1=(uv1+_EyeParam1.xy);
                float2 uv1_1=uv1*sin(_EyeParam1.z);
                float2 uv1_2=float2(uv1.x*cos(_EyeParam1.z)-uv1_1.x,uv1.x*cos(_EyeParam1.z)+uv1_1.y)+float2(0.5,0.5);
                o.uv=v.uv;
                o.uv2 = TRANSFORM_TEX(v.uv2, _EyeTex);
                o.uv3=TRANSFORM_TEX(v.uv3,_EyeSpecTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                if(i.uv2.x==0 && i.uv2.y==0)
                {
                    discard;
                }
                float4 eyetex=tex2D(_EyeTex,float2(((i.uv.x-_UVOffset)/_UVTest)+_UVBack,i.uv.y));
                //float4 eyetex=tex2D(_EyeTex,float2((i.uv2.x-0.25)/2,i.uv2.y/2));
                float4 eyespectex=tex2D(_EyeSpecTex,i.uv2);
                return eyetex+eyespectex;
            }
            ENDCG
        }
    }
}
