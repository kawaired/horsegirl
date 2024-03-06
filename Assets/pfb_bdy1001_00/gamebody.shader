Shader "Unlit/gamebody"
{
    Properties
    {
        _ToonStep("toonstep",range(-1,1))=0
        _ToonFeather("toonfeather",range(-1,1))=1
        _BrightColor("brightcolor",color)=(1,1,1,1)
        _DarkColor("darkcolor",color)=(1,1,1,1)
        _GlobalBright("globalbright",color)=(0,0,0,0)
        _GlobalDark("globaldark",color)=(0,0,0,0)
        _VertexColorToonPower("vertexcolortoonpower",range(-1,2))=1
        _EnvTex("envtex",2D)="white"{}
        _EnvRate("envrate",range(0,1))=0
        _EnvBias("envbias",range(0,1))=0
        _FoldScale("foldscale",range(0,4))=1


        _LightTex("lighttex",2D)="white"{}
        _DarkTex("darktex",2D)="white"{}
        _RimTex("rimtex",2D)="white"{}
        _FoldTex("foldtex",2D)="white"{}
        _DiffuseLight("diffuselight",color)=(0.2,0.2,0.2,0.2)
        _DiffuseRate("diffuserate",range(-2,2))=0.9
        _MetalRate("metalrate",range(-2,2))=0.2
        _ColorRate("colorrate",range(-2,2))=0
        _DiffusePow("diffusepow",range(0.01,1))=0.5
        _DiffuseOffset("diffuseoffset",range(0.01,0.499))=0.1
        
        _SpecularLight("specularlight",color)=(0.3,0.3,0.3,0.3)
        _SpecularRate("specularrate",range(0,1))=0.2
        _RimHOffset1("rimhoffset1",range(-1,1))=0
        _RimVOffset1("rimvoffset1",range(-1,1))=0
        _RimColor1("rimcolor1",color)=(0.3,0.3,0.3,0.3)
        _RimHOffset2("rimhoffset2",range(-1,1))=0
        _RimVOffset2("rimvoffset2",range(-1,1))=0
        _RimColor2("rimcolor2",color)=(0.3,0.3,0.3,0.3)
        _RimPow("rimpow",range(1,20))=1
        _FresnelOffset("fresneloffset",range(0,1))=0
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
                float3 normal:NORMAL;
                float4 color:COLOR;
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
            float _ToonStep;
            float _ToonFeather;
            float _FoldScale;

            sampler2D _LightTex;
            float4 _LightTex_ST;
            sampler2D  _DarkTex;
            float4 _DarkMain_ST;
            sampler2D _RimTex;
            float4 _RimTex_ST;
            sampler2D _FoldTex;
            float4 _FoldTex_ST;
            sampler2D _EnvTex;
            float4 _EnvTex_ST;

            float4 _BrightColor;
            float4 _DarkColor;
            float4 _GlobalBright;
            float4 _GlobalDark;
            float _VertexColorToonPower;
            float _EnvRate;
            float _EnvBias;

            float4 _DiffuseLight;
            float _DiffuseRate;
            float _MetalRate;
            float _ColorRate;
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
               o.worldnormal=UnityObjectToWorldNormal(v.normal);
               o.viewnormal=mul(UNITY_MATRIX_IT_MV,v.normal);
               o.color=v.color;
                return o;
            }

            float ZeroStep(float x)
            {
                return (x>=0)-(x<0);
            }

            float3 OffsetVector(float3 origionvector,float3 aimvector,float offsetvalue)
            {
                return  lerp(origionvector,aimvector*(ZeroStep(offsetvalue)),abs(offsetvalue));
            }

            float Sigmoid(float x)
            {
                return 1/(1+pow(2,-x));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 lighttex=tex2D(_LightTex,i.uv);
                float4 darktex=tex2D(_DarkTex,i.uv);
                float4 rimtex=tex2D(_RimTex,i.uv);//y轴表示材质的区分
                //return rimtex.y;
                float4 foldtex=tex2D(_FoldTex,i.uv);//x轴漫反射容易出现阴影的区域的程度，y轴表示金属区域的高光反射显示区域
                //return foldtex.y;
                //return foldtex.x;
                float lambert=dot(i.worldnormal,_WorldSpaceLightPos0);
                float halflambert=lambert*0.5+0.5;
                //float lambertfactor=0.5*(lambert+1)*foldtex.x;
                float lambertfactor=saturate(((_ToonStep-_ToonFeather-halflambert)/_ToonFeather)+1)*(_ToonFeather>0);
                float halffactor=min(halflambert-0.5,0)+0.5;
                //return halflambert;
                //return halffactor;
                halffactor=1-2*halffactor*(1-i.color.w)*_VertexColorToonPower;
                //return i.color.w;
                //return halffactor;

                // lighttex=lerp(float4(1,1,1,1),_BrightColor,halffactor)*lighttex;
                // darktex=lerp(float4(1,1,1,1),_DarkColor,halffactor)*darktex;

                lighttex=lighttex+_BrightColor*halffactor;
                darktex=darktex+_DarkColor*halffactor;

                //return lambertfactor;
                float4 diffusecolor=lerp(lighttex,darktex,lambertfactor);
                //return diffusecolor;
                float4 diffusetone=lerp(_GlobalBright,_GlobalDark,lambertfactor);
                //return diffusetone;
                float colorfactor=(foldtex.x*_DiffuseRate+foldtex.y*_MetalRate+foldtex.z*_ColorRate);
                //return colorfactor;
                diffusecolor=lerp(diffusecolor,diffusetone,colorfactor);
                return diffusecolor;
                float4 envtex=tex2D(_EnvTex,(i.viewnormal.xy+float2(1,1))*0.5);
                //return envtex;
                float4 envcolor=envtex*diffusecolor;
                float envfactor=rimtex.y*_EnvRate;
                float4 specularcolor=rimtex.y*envtex*_SpecularLight*_SpecularRate;
                //return envtex;
                //return specularcolor;
                return diffusecolor+specularcolor;
                //return envfactor;
                // return envcolor;
               
                return rimtex.y;
                 //return foldtex.y*_MetalRate+foldtex.x*_DiffuseRate;
                // return foldtex.x*_DiffuseRate;
                return diffusecolor;
                //return diffusecolor*foldtex.x*_DiffuseRate;
                //return diffusecolor*foldtex.y*_MetalRate;
                //return diffusecolor*(foldtex.x*_DiffuseRate+foldtex.y*_MetalRate+foldtex.z*_ColorRate);
                 
                //lambertfactor=Sigmoid((lambertfactor*2-1)*10);
                // lambertfactor=lambertfactor*2-1;
                // lambertfactor=0.5*(ZeroStep(lambertfactor)*pow(abs(lambertfactor),_DiffusePow)+1);
                // float4 diffusecolor=lerp(darktex,lighttex, smoothstep(0.5-_DiffuseOffset,0.5+_DiffuseOffset,lambertfactor));
                // //return diffusecolor;
                // // return lambertfactor>0.5;
                // // float4 diffusecolor=lighttex*(lambertfactor>0.5)+darktex*(lambertfactor<=0.5);
                // diffusecolor=diffusecolor*_DiffuseLight*_DiffuseRate*(1+foldtex.y*_MetalRate);
                // float4 matcabtex=tex2D(_MatCabTex,(i.viewnormal.xy+float2(1,1))*0.5);
                // float4 specularcolor=rimtex.y*matcabtex*_SpecularLight*_SpecularRate;
                // //return specularcolor+diffusecolor;
                
                // float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex.xyz);
                // float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
                // float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
                // float3 offsetviewdir1=OffsetVector(viewdir,camxdir,_RimHOffset1);
                // offsetviewdir1=OffsetVector(offsetviewdir1,camydir,_RimVOffset1);
                // float fresnel1=dot(offsetviewdir1,i.worldnormal);
                // //fresnel1=pow(1-fresnel1-_FresnelOffset/fresneloffset,_RimPow);
                // fresnel1=pow(saturate(_FresnelOffset-fresnel1),_RimPow);
                // //return rimtex.z;
                // float4 rimcolor1=(fresnel1>0.9)*rimtex.z*_RimColor1;
                // float4 finalcolor=specularcolor+diffusecolor+rimcolor1;
                // return finalcolor;
            }
            ENDCG
        }
    }
}
