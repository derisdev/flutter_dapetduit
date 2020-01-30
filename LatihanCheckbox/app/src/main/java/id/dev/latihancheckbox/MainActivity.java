package id.dev.latihancheckbox;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private CheckBox cbBandung, cbBogor, cbBanjarmasin, cbBontang;
    private Button btPeriksaNilai;
    private TextView tvNilai;


    int nilaiBandung = 0;
    int nilaiBogor = 0;
    int nilaiBM = 0;
    int nilaiBontang = 0;

    int nilaiTotal =0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        cbBandung = findViewById(R.id.bandung);
        cbBogor = findViewById(R.id.bogor);
        cbBanjarmasin = findViewById(R.id.banjarmasin);
        cbBontang = findViewById(R.id.bontang);
        btPeriksaNilai = findViewById(R.id.bt_periksanilai);
        tvNilai = findViewById(R.id.nilai);

        cbBandung.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (((CheckBox) view).isChecked()) {
                    nilaiBandung = 10;
                }
                else {
                    nilaiBandung = 0;
                }
            }
        });

        cbBogor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (((CheckBox) view).isChecked()) {
                    nilaiBogor = 10;
                }
                else {
                    nilaiBogor = 0;
                }
            }
        });

        cbBanjarmasin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (((CheckBox) view).isChecked()) {
                    nilaiBM = 5;
                }
                else {
                    nilaiBM = 0;
                }
            }
        });
        cbBontang.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (((CheckBox) view).isChecked()) {
                    nilaiBontang = 5;
                }
                else {
                    nilaiBontang = 0;
                }
            }
        });

        btPeriksaNilai.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                nilaiTotal = nilaiBandung + nilaiBogor - nilaiBM - nilaiBontang;
                tvNilai.setText(Integer.toString(nilaiTotal));
            }
        });


    }
}
