using UnityEngine;
using System.Collections;

public class Goutte : MonoBehaviour
{
    bool mortel = false;
    float duree = 3.0f;
    float decompte = 3.0f;

    SpringJoint2D springJoint;

    // au début de l'univers
    void Start() {
        springJoint = GetComponent<SpringJoint2D>();
        // on est seul, pas d'attirance (pour l'instant)
        springJoint.enabled = false;
    }

    void Update()
    {
	
        // si on doit mourir
        if (mortel)
        {
            UpdateMortalite();
        }

    }

    void UpdateMortalite()
    {
        // décompter le temps
        decompte -= Time.deltaTime;
        // si plus de temps
        if (decompte < 0)
        {   // Die #@*%§¶£€¥!!!
            Destroy(this.gameObject);
        }

        // si on doit se rapetisser (1.0 > 0.0)
        float echelle = decompte / duree;
        // appliquer
        transform.localScale = new Vector2(echelle, echelle);

        // H=Teinte, S=Saturation, B=Luminosité, A=Alpha
        //Color color = Color.HSVToRGB(0.0f, 0.0f, 1.0f);
        Color color = Color.white;
        //color.a = echelle;
        GetComponent<SpriteRenderer>().color = color;

    }


    void OnCollisionEnter2D(Collision2D impact) {
        // si on n'est pas attiré par quoi que ce soit
        if (!springJoint.enabled)
        {   // si l'autre est aussi une goutte
            if (impact.gameObject.tag == "Goutte")
            {   // activer le springJoint
                springJoint.enabled = true;
                // s'attacher à l'autre rigidbody
                springJoint.connectedBody = impact.gameObject.GetComponent<Rigidbody2D>();
                // essayer de configurer la distance
                springJoint.distance = 0.25f;
            }
        }

    }

}
