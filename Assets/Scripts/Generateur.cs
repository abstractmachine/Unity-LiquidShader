using UnityEngine;
using System.Collections;

public class Generateur : MonoBehaviour {

    // le prefab que je veux créer
    public GameObject prefab;


	void Update () {

        if (Input.GetKeyDown(KeyCode.B))
        {
            Generate(Color.blue);
        }

        if (Input.GetKeyDown(KeyCode.R))
        {
            Generate(Color.red);
        }

        if (Input.GetKeyDown(KeyCode.J))
        {
            Generate(Color.yellow);
        }

	}


    void Generate(Color color) {
        
        // créer un objet ET garder la référence de l'objet qu'on vient de créer
        GameObject nouvelObjet = (GameObject)Instantiate(prefab);
        // dire à (ce nouvel) objet de s'attacher à moi
        nouvelObjet.transform.SetParent(this.transform);
        // juste un peu de bordel à la génération
        float force = 1.0f;
        Vector2 randomVector = new Vector2(Random.Range(-force,force), Random.Range(-force,force));
        nouvelObjet.GetComponent<Rigidbody2D>().AddForce(randomVector);
        // colorier la goutte
        nouvelObjet.GetComponent<SpriteRenderer>().color = color;

    }
}
